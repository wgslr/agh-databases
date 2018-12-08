#!/bin/env python3

import pymongo
import re
from bson.son import SON
from bson.code import Code

HOST = 'localhost'
PORT = 27017
DB = 'jeopardy'
COLLECTION = 'question'


def find_mentions(collection, word):
    """
    Find mentions of given word in the question or answer
    """

    regex = re.compile(word)
    return collection \
        .find({'$or': [{'question': regex}, {'answer': regex}]}) \
        .sort('show_number')


def format_question(question):
    """
    Pretty format a question document
    """
    return """category: {q[category]}
show no:  {q[show_number]}
date:     {q[air_date]}
round:    {q[round]}
value:    {q[value]}
question: {q[question]}
answer:   {q[answer]}
""".format(q=question)


def yearly_report(collection):
    """
    Return generator for yearly count of shows
    aired and their initial no.
    """
    return collection.aggregate([
        {'$addFields': {
            'year': {'$year': {'$toDate': "$air_date"}},
            'show_number': {'$toInt': "$show_number"}
        }},
        {'$group':
         {'_id': "$show_number", 'year': {'$min': "$year"}}
         },
        {'$group':
         {'_id': "$year", 'count': {'$sum': 1}, 'first_show': {'$min': "$_id"}}
         },
        {'$sort': SON([('count', -1), ('first', -1)])}
    ])


def frequencies(collection):
    # fixme db.question.createIndex({air_date: 1})

    mapper = Code("""
        function() {
            const value = {
            earliest: new Date(this.air_date),
            latest: new Date(this.air_date),
            avg: 0, // average time difference
            count: 0 // element in the average
            }
            emit(this.round, value)
        }
    """)

    reducer = Code("""
        function(key, value) {
            // sort dates in ascending order
            let v=value[0]

            for(let i=1; i < value.length; ++i) {
                const curr=value[i]
                const diff=curr.earliest - v.latest
                const newCount=v.count + curr.count + 1

                if (diff < 0) {
                    // sanity check
                    throw "ordering error"
                }

                v.avg=(v.avg * v.count + curr.avg * curr.count + diff) / newCount
                v.latest=curr.latest
                v.count=newCount
            }
            return v
        }
    """)

    finalizer = Code("""
        function(key, reducedValue) {
            const MILLIS_IN_A_DAY=86400000
            return reducedValue.avg / MILLIS_IN_A_DAY
        }
    """)

    resultscol = collection.map_reduce(
        mapper, reducer, "freq", sort=SON([("air_date", 1)]), finalize=finalizer)
    return resultscol


if __name__ == '__main__':
    client = pymongo.MongoClient(HOST, PORT)
    questions = client[DB][COLLECTION]

    print("\n".join(str(x) for x in yearly_report(questions)))

    mrresults = frequencies(questions)
    print(list(mrresults.find({'_id': 'Tiebreaker'})))

    print("Country of interest [Poland]:", end=' ')
    inp = input()
    print(inp)
    country = inp if inp != "" else "Poland"

    for q in find_mentions(questions, country):
        print(format_question(q))

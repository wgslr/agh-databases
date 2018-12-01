#!/bin/env python3

import pymongo
import re

HOST = 'localhost'
PORT = 27017
DB = 'jeopardy'
COLLECTION = 'question'

def find_mentions(collection, word):
    regex = re.compile(word)
    return collection \
        .find({'$or': [{'question': regex}, {'answer': regex}]}) \
        .sort('show_number')

def format_question(question):
    # print(question)
    return """category: {q[category]}
show no:  {q[show_number]}
date:     {q[air_date]}
round:    {q[round]}
value:    {q[value]}
question: {q[question]}
answer:   {q[answer]}
""".format(q = question)


if __name__ == '__main__':
    client = pymongo.MongoClient(HOST, PORT)
    questions = client[DB][COLLECTION]

    print("Country of interest [Poland]:", end=' ')
    inp = input()
    print(inp)
    country = inp if inp != "" else "Poland"

    for v in find_mentions(questions, country):
        print(format_question(v))
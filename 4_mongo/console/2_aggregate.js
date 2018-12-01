use jeopardy
db.question.aggregate([
        {$addFields:
          {
            year: {$year: {$toDate: "$air_date"}},
            show_number: {$toInt: "$show_number"}
          }
        },
        {$group:
          {_id: "$show_number", year: {$min: "$year"}}
        },
        {$group:
          {_id: "$year", count: {$sum: 1}, first_show: {$min: "$_id"}}
        },
        {$sort:
          {count: -1, first: -1}
        }
])

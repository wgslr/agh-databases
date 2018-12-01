db.question.aggregate([
        {$addFields:
          {year: {$year: {$toDate: "$air_date"}}}
        },
        {$group:
          {_id: "$year", count: {$sum: 1}, first: {$min: "$show_number"}}
        },
        {$sort:
          {count: -1}
        }
])

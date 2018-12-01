db.question.mapReduce(
  function() {
    const value = {
      latest: new Date(this.air_date),
      avg: 0, // average time difference
      count: 0 // element in the average
    }
    emit(this.round, value)
  },
  function(key, value) {
    // sort dates in ascending order
    value = value.sort((x, y) => x.latest - y.latest)

    let v = value[0]

    for(let i = 1; i < value.length; ++i) {
      const newCount = v.count + 1;
      v.avg = (v.avg * v.count + (value[i].latest - v.latest)) / newCount
      v.latest = value[i].latest
      v.count = newCount
    }
    return v;
  },
  {
    out: "freq",
    finalize: function(key, reducedValue) {
      const MILLIS_IN_A_DAY = 86400000;
      return reducedValue.avg / MILLIS_IN_A_DAY
    }
  }
)

db.question.createIndex({air_date: 1})
db.question.mapReduce(
  function() {
    const value = {
      earliest: new Date(this.air_date),
      latest: new Date(this.air_date),
      avg: 0, // average time difference
      count: 0 // element in the average
    }
    emit(this.round, value)
  },
  function(key, value) {
    // sort dates in ascending order
    let v = value[0];

    for(let i = 1; i < value.length; ++i) {
      const curr = value[i];
      const diff = curr.earliest - v.latest;
      const newCount = v.count + curr.count + 1;

      if (diff < 0) {
        // sanity check
        throw "ordering error";
      }

      v.avg = (v.avg * v.count + curr.avg * curr.count + diff) / newCount;
      v.latest = curr.latest;
      v.count = newCount;
    }
    return v;
  },
  {
    out: "freq",
    sort: {air_date: 1},
    finalize: function(key, reducedValue) {
      const MILLIS_IN_A_DAY = 86400000;
      return reducedValue.avg / MILLIS_IN_A_DAY;
    }
  }
)

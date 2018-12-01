db.question.mapReduce(
  function() {
    emit(this.round, new Date(this.air_date))
  },
  function(key, value) {
    const MILLIS_IN_A_DAY = 86400000;
    let prevDate = null;
    let differences = []

    value = value.sort((x, y) => x - y)

    for(let i = 0; i < value.length; ++i) {
      if(prevDate != null){
        diffDays = (value[i] - prevDate) / MILLIS_IN_A_DAY
        differences.push(diffDays)
      }
      prevDate = value[i]
    }
    // average number of days between rounds appeared
    return Array.sum(differences) / differences.length
  },
  {
    out: "freq"
  }
)

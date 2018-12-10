// Wszystkie pytania gdzie w pytaniu lub odpowiedzi znajduje się słowo "Poland"
// posrtowane w kolejności odbywania się nagrań
db.question.
  find({
    $or: [
      {question: {$regex: /Poland/}},
      {answer: {$regex: /Poland/}}]
  }).
  sort({show_number: 1})

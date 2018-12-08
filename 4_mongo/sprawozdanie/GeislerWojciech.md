---
title: "Bazy danych: Hibernate"
author: Wojciech Geisler
geometry: margin=2cm
output: pdf_document
toc: true
---

## Konfiguracja środowiska

Do uruchomienia lokalnej instancji mongodb użyłem obrazu dockera `mongo:4.0`. Całość opisuje plik `docker-compose.yaml`:

```yaml
version: "2.2"

services:
  mongo:
    image: mongo:4.0
    network_mode: host
    volumes:
      - "db-mongo:/data/db"

volumes:
  "db-mongo":
```


## Import danych

W celu użycia polecenia `mongoimport` konieczne było edycja pliku `JEOPARDY_QUESTIONS1.json` aby zawierał osobne obiekty json, nie objęte listą, to znaczy do postaci:

```json
  {
    "category": "HISTORY",
    "air_date": "2004-12-31",
    "question": "'For the last 8 years of his life, Galileo was under house arrest for espousing this man's theory'",
    "value": "$200",
    "answer": "Copernicus",
    "round": "Jeopardy!",
    "show_number": "4680"
  }
    ...
  {
    "category": "HISTORIC NAMES",
    "air_date": "2006-05-11",
    "question": "'A silent movie title includes the last name of this 18th c. statesman & favorite of Catherine the Great'",
    "value": null,
    "answer": "Grigori Alexandrovich Potemkin",
    "round": "Final Jeopardy!",
    "show_number": "4999"
  }
```

Import:

```bash
mongoimport --db jeopardy --collection question --type json --file questions.json
```

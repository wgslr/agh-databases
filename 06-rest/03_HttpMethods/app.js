// File 03_HttpMethods/app.js
// 
const express = require("express");
const app = express();

function printReqSummary(request) {
  console.log(`Handling ${request.method} ${request.originalUrl}`);
}

/* Store items collection in this array */
let items = [];

/* GET / -- Show main page */
app.get("/", function(request, response) {
  printReqSummary(request);
  response.send(
    `<h1>HTTP Methods</h1><ul>
      <li>Show items (GET /item)</li>
      <li>Add an item (PUT /item/:name)</li>
      <li>Remove an item (DELETE /item/:name)</li></ul>`
  );
});

/* GET /item -- Show all items from the collection */
app.get("/item", function(request, response) {
  printReqSummary(request);
  response.send(`<p>Available items: ${items.toString()}</p>`);
});

/* POST /item/ -- add item with named from param ?name */
app.post("/item/", function(request, response) {
  const itemName = request.query.name;
  if (itemName === undefined) {
    response.status(400);
    response.send("Cannot add item: missing name parameter");
  } else {
    if (items.includes(itemName)) {
      response.send(`<p>Item "${itemName}" already in collection</p>`);
    } else {
      items.push(itemName);
      response.send(`<p>Item "${itemName}" added successfully</p>`);
    }
  }
    
});

/* PUT /item/:name -- modify item :name */
app.put("/item/:name", function(request, response) {
  printReqSummary(request);

  const itemName = request.params.name;
  const newName = request.query.name;

  if (newName === undefined) {
    response.status(400);
    response.send("Cannot modify item: missing name parameter");
  } else if (!items.includes(itemName)) {
    response.status(404);
    response.send("Cannot modify item: not found");
  } else {
    items[items.indexOf(itemName)] = newName;
    response.send(`<p>Item "${itemName}" changed to "${newName}"</p>`);
  }
});

/* DELETE /item/:name -- remove a given item from the collection */
app.delete("/item/:name", function(request, response) {
  printReqSummary(request);
  const itemName = request.params.name;
  /* Is the item in collection? */
  if (items.includes(itemName)) {
    items = items.filter(item => item !== itemName);
    response.send(`<p>Item "${itemName}" removed successfully</p>`);
  } else {
    response.send(`<p>Item "${itemName}" doesn't exists</p>`);
  }
});

app.listen(3000);

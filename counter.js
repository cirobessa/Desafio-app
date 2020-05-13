const express = require("express");

// contador
var contador = 0;

var app = express();

// Registra evento nas requisições HTTP GET /visit
app.get("/", (req, res) => {
  contador++;

  res.writeHeader(200, { "Content-Type": "text/html; charset=utf-8" });

  res.write("Olá!\n");

  res.write("Você é o visitante de número " + contador + ", Seja Bem vindo!\n");

  res.end();
});

app.listen(8082, "0.0.0.0");

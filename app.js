var Firebase = require('./firebase-node');

var db = new Firebase('https://io.firebaseio.com');

console.log("Listening for changes");

db.on("value", function(v){
  console.log(v.val());
});

//db.child("blake").set('from me');

//var express = require('express');

//var app = express.createServer(express.logger());

//app.get('/', function(request, response) {
  //response.send('Hello World!');
//});

//var port = process.env.PORT || 5000;
//app.listen(port, function() {
  //console.log("Listening on " + port);
//});

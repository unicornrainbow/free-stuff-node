var Firebase = require('./firebase-node');

var db = new Firebase('https://io.firebaseio.com/items');
var geohash = require('ngeohash');

console.log("Listening for changes");

db.on("child_added", function(snapshot){
  var value = snapshot.val(),
      lat   = value.lat,
      lon   = value.lon,
      hash  = geohash.encode(lat, lon);

  snapshot.ref().update({geohash: hash});
  snapshot.ref().setPriority(hash);

  //console.log(value);
  //console.log(lat);
  //console.log(lon);
  //console.log(hash);
  //console.log(geohash.encode(37.8324, 112.5584));
  //console.log(v.val());
});

//db.child("blake").set('from me');

var express = require('express');

var app = express.createServer(express.logger());

app.get('/', function(request, response) {
  response.send('Fuck off!');
});

var port = process.env.PORT || 5000;
app.listen(port, function() {
  console.log("Listening on " + port);
});


//4 digits - 40k e/w 20k n/s (city)
//5 digits - 5k


// Get some stuff
db.startAt("9q8yy").endAt("9q8yz").on("value", function(snap) {
  console.log(snap.val());
});

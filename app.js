var Firebase = require('./firebase-node');

var db = new Firebase('https://io.firebaseio.com/items');
var geohash = require('ngeohash');
var base32 = require("encode32");

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

var find_near = function(lat, lon, callback) {
  var hash = geohash.encode(lat, lon);
  console.log(hash);
  hash = base32.decode(hash);
  console.log(hash);
  var zoom = 1000000;
  var upper = base32.encode(hash + zoom).toLowerCase()
  console.log("Upper: " + upper);
  var lower = base32.encode(hash - zoom).toLowerCase()
  db.startAt(lower).endAt(upper).on("value", function(snap) {
    callback(snap.val());
  });
}

find_near(37.759079, -122.428998, function(result) {
  console.log(result);
});

//(function () {
  //// Get some stuff
  //var base32 = "0123456789abcdefghijklmnopqrstuvwxyz";
  //var base32floor = function( val, digits ) {
         //return val.substring(0,digits);
  //}
  //var base32ceil = function( val, digits ) {
         //return val.substring(0,digits-1) + base32[base32.indexOf(val.substring(digits-1,digits))+1];
  //}



  //var base32add = function( str, n ) {
    //if(str.length == 0)
      //return str;
    //var old = str.substring( 0, str.length - 2 ),
        //c = str.substring( str.length-2 ),
        //cind = base32.indexOf( c )+n;

    //if ( cind >= 32 ) {
      //old = base32add( old, n - 32 );
      //c = "0";
    //} else {
      //c = base32[cind];
    //}

    //str = old + c;
  //}


  //var hash = "9q8yy53up";
  ////var length = 3; // Acroos town
  ////var length = 4; // Between down the street and across town
  //var length = 5; // Down the stree
  ////var length = 6;  // Hyper local
  //var from = base32floor(hash, length);
  //var to = base32ceil(hash, length);

  //db.startAt(from).endAt(to).on("value", function(snap) {
    //console.log(snap.val());
  //});
//}());

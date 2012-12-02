var Firebase = require('./firebase-node');

var db = new Firebase('https://io.firebaseio.com');

console.log("Listening for changes");

db.on("value", function(v){

  console.log(v.val());
});

//db.child("blake").set('from me');

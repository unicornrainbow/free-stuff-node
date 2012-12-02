geohash  = require "ngeohash"
base32   = require "encode32"
Firebase = require "./firebase-node"
express  = require "express"

update_geohash = (snapshot) ->
  value = snapshot.val()
  console.log "Processing #{JSON.stringify(value)}"
  [lat, lon] = [value.lat, value.lon]
  hash = geohash.encode(value.lat, value.lon)

  ref = snapshot.ref()
  ref.update geohash: hash
  ref.setPriority hash

db = new Firebase("https://io.firebaseio.com/items")
db.on "child_added", update_geohash

app = express.createServer(express.logger())
app.get "/", (request, response) ->
  response.send "Fuck off!"

port = process.env.PORT or 5000
app.listen port, ->
  console.log "Listening on " + port

#4 digits - 40k e/w 20k n/s (city)
#5 digits - 5k

#class Item
  #@find_nearby: (lat, lon, callback) ->
    #hash = geohash.encode(lat, lon)
    #console.log hash
    #hash = base32.decode(hash)
    #console.log hash
    #zoom = 1000000
    #upper = base32.encode(hash + zoom).toLowerCase()
    #console.log "Upper: " + upper
    #lower = base32.encode(hash - zoom).toLowerCase()
    #db.startAt(lower).endAt(upper).on "value", (snap) ->
      #callback snap.val()


#Item.find_nearby 37.759079, -122.428998, (result) ->
  #console.log result

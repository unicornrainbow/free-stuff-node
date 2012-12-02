express  = require "express"
Firebase = require "./firebase-node"
config = require "./config"
ItemGeohasher = require './lib/item_geohasher'

db = new Firebase("#{config.firebase_root}/items")
db.on "child_added", ItemGeohasher.update_geohash

app = express(express.logger())
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

express = require "express"
Firebase = require "./firebase-node"
config = require "./config"
Item = require './lib/item'

db = new Firebase("#{config.firebase_root}/items")

# Listen for new items and geohash them as they come in.
db.on "child_added", (snapshot) ->
  (new Item(snapshot)).update_geohash()

app = express()
app.get "/", (request, response) ->
  response.send "Hello World!"

port = process.env.PORT or 5000
app.listen port, -> console.log "Listening on " + port

Item.db = db
Item.nearby 37.759079, -122.428998, (result) ->
  console.log result

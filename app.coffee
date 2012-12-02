express = require "express"
Firebase = require "./firebase-node"
config = require "./config"
Backbone = require "backbone"
Item = require './lib/item'

db = new Firebase("#{config.firebase_root}/items")

# Listen for new items and geohash them as they come in.
db.on "child_added", (snapshot) ->
  (new Item(snapshot)).update_geohash()

# Share db with item
Item.db = db

# Web Server
app = express()
app.get "/nearby", (req, res) ->
  #Item.nearby 37.759079, -122.428998, (result) ->
  Item.nearby lat: req.query.lat, lon: req.query.lon, zoom: req.query.zoom, (result) ->
    res.send result
    res.end()

port = process.env.PORT or 5000
app.listen port, -> console.log "Listening on " + port

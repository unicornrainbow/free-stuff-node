express = require "express"
Firebase = require "./firebase-node"
config = require "./config"
Backbone = require "backbone"
BackboneFirebase = require "./lib/backbone-firebase"
Item = require './lib/item'

db = new Firebase("#{config.firebase_root}/items")

# Listen for new items and geohash them as they come in.
db.on "child_added", (snapshot) ->
  (new Item(snapshot)).update_geohash()

# Share db with item
Item.db = db

# Web Server
app = express()
app.get "/nearby.json", (req, res) ->
  #Item.nearby 37.759079, -122.428998, (result) ->
  Item.nearby lat: req.query.lat, lon: req.query.lon, zoom: req.query.zoom, (result) ->
    res.send result
    res.end()

port = process.env.PORT or 5000
app.listen port, -> console.log "Listening on " + port

class Item2 extends Backbone.Model

class ItemsCollection extends Backbone.Collection
  url: "items"
  model: Item2

collection = new ItemsCollection()

#item = collection.create
  #name: ""
  #lat: 31.9685988
  #lon: -99.9018131

#console.log texas.toJSON


#toyCollection.new(
#Backbone.sync()
#texas = new Item(name: "Texas", lat: 31.9685988, lon: -99.9018131)
#texas.collection = toyCollection
#toy.save()
#console.log toy.toJSON()
#toyCollection.add(toy)
#toy.save()

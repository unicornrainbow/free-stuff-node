geohash  = require "ngeohash"
base32   = require "encode32"

class Item
  constructor: (snapshot) ->
    @ref = snapshot.ref()
    @attributes = snapshot.val()

  update_geohash: ->
    console.log "Processing #{JSON.stringify(@attributes)}"
    hash = @geohash()
    @ref.update geohash: hash # Save value
    @ref.setPriority hash  # Index with priority

  geohash: ->
    geohash.encode(@get('lat'), @get('lon'))

  get: (name) ->
    @attributes[name]

  @nearby: (opts={}, callback) ->
    lat = new Number(opts.lat) || 37.759079
    lon = new Number(opts.lon) || -122.428998
    zoom = new Number(opts.zoom) || 10
    console.log zoom
    zoom = Math.pow(2, zoom)
    console.log zoom
    hash = geohash.encode(lat, lon)
    hash = base32.decode(hash)

    # Compute upper and lower bounds of search
    upper = base32.encode(hash + zoom).toLowerCase()
    lower = base32.encode(hash - zoom).toLowerCase()

    @db.startAt(lower).endAt(upper).on "value", (snap) ->
      callback snap.val()

module.exports = Item

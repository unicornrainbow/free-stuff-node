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

module.exports = Item

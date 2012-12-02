geohash  = require "ngeohash"
base32   = require "encode32"

class ItemGeohasher
  @update_geohash: (snapshot) ->
    value = snapshot.val()
    console.log "Processing #{JSON.stringify(value)}"
    [lat, lon] = [value.lat, value.lon]
    hash = geohash.encode(value.lat, value.lon)

    ref = snapshot.ref()
    ref.update geohash: hash
    ref.setPriority hash

module.exports = ItemGeohasher

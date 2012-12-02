#
#     Backbone <-> Firebase v0.0.3
#
#     Started as a fork of Backpusher.js (https://github.com/pusher/backpusher)
#
#     Backbone <-> Firebase (c) 2012 Alex Bain
#     Backpusher originally (c) 2011-2012 Pusher
#
#     This script may be freely distributed under the MIT license.
#
Backbone = require "backbone"
Firebase = require "../firebase-node"
_ = require "underscore"

# Note: Add your appname to the end of this string
urlPrefix = "http://io.firebaseio.com/"
defaults =
  urlPrefix: urlPrefix
  idAttribute: "_firebase_name"

BackboneFirebase = (collection, options) ->
  @reference = new Firebase(urlPrefix + collection.url)
  @collection = collection

  # Extend the defaults with the options provided and set as `this.options`.
  @options = defaults
  if options
    for k of options
      @options[k] = options[k]

  # Optionally pass the urlPrefix in.
  @reference = new Firebase(@options.urlPrefix + collection.url) if @options.urlPrefix

  # Optionally specify the idAttribute to use.
  @idAttribute = @options.idAttribute
  if @options.events
    @events = @options.events
  else
    @events = BackboneFirebase.defaultEvents
  @_bindEvents()
  @initialize collection, options
  this

_.extend BackboneFirebase::, Backbone.Events,
  initialize: ->

  _bindEvents: ->
    return  unless @events
    for event of @events
      @reference.on event, _.bind(@events[event], this)  if @events.hasOwnProperty(event)

  _add: (pushed_model) ->
    Collection = @collection

    # Set the model id attribute to be the firebase reference name.
    attr = pushed_model.val()
    attr[@idAttribute] = pushed_model.name()
    model = new Collection.model(attr)
    Collection.add model
    @trigger "remote_create", model
    model

BackboneFirebase.defaultEvents =
  child_added: (pushed_model) ->
    @_add pushed_model

  child_changed: (pushed_model) ->

    # Get existing model using the reference name as the model id.
    model = @collection.get(pushed_model.name())
    if model
      model = model.set(pushed_model.val())
      @trigger "remote_update", model
      model
    else
      @_add pushed_model

  child_removed: (pushed_model) ->

    # Get existing model using the reference name as the model id.
    model = @collection.get(pushed_model.name())
    if model
      @collection.remove model
      @trigger "remote_destroy", model
      model


# Original Backbone.sync method from v0.9.2
Backbone.sync = (method, model, options) ->
  console.log "syncing"

  # Verify Firebase object exists
  return false  if typeof Firebase is `undefined`

  # Default options, unless specified.
  options or (options = {})
  url = getValue(model, "url") or urlError()

  # Setup the Firebase Reference
  ref = new Firebase(urlPrefix + url)

  # Map CRUD to Firebase actions
  switch method
    when "create"
      ref.push model.toJSON(), (success) ->
        if success and options.success
          options.success()
        else options.error()  if not success and options.error

    when "read"
      ref.once "value", (data) ->
        data = _.toArray(data.val())
        options.success data, "success", {}  if options.success

    when "update"
      ref.set model.toJSON(), (success) ->
        if success and options.success
          options.success()
        else options.error()  if not success and options.error

    when "delete"
      ref.remove (success) ->
        if success and options.success
          options.success()
        else options.error()  if not success and options.error

    else
  ref

getValue = (object, prop) ->
  return null  unless object and object[prop]
  (if _.isFunction(object[prop]) then object[prop]() else object[prop])

exports.BackboneFirebase = BackboneFirebase

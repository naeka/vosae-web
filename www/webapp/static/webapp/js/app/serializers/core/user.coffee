###
  Serializer for model `Vosae.User`.

  @class UserSerializer
  @extends Vosae.ApplicationSerializer
  @namespace Vosae
  @module Vosae
###

Vosae.UserSerializer = Vosae.ApplicationSerializer.extend
  attrs:
    specificPermissions:
      embedded: 'always'
    settings:
      embedded: 'always'

  serializeHasMany: (record, json, relationship) ->
    attr = relationship.key
    key = @keyForAttribute(attr)
    config = @get("attrs")

    finalizer = ->
      return json

    # HasMany is not embedded
    if not config or (not isEmbedded(config[attr]) and not hasEmbeddedIds(config[attr]))
      json[key] = record.get(attr).map (hasMany) =>
        @urlify hasMany.constructor, hasMany.get('id')
      return

    # HasMany is embedded
    else
      # Create a main promise that will contains an array of promises which will
      # be resolved once his related record will be serialized
      return new Ember.RSVP.Promise (resolve) =>
        promises = []
        record.get(attr).map((relation) ->
          promises.push Ember.RSVP.resolve(relation.serialize()).then (data) ->
            data
        , this)

        # Once all records in hasMany are serialized, resolve the main promise
        Ember.RSVP.all(promises).then (hasMany) ->
          if attr is "specificPermissions"
            obj = {}  
            $.map hasMany, (permission) ->
              obj[permission.name] = permission.value
            hasMany = obj
          json[key] = hasMany
          resolve()

    return

# Checks config for embedded flag
isEmbedded = (config) ->
  config and (config.embedded is "always" or config.embedded is "load")

# Checks config for included ids flag
hasEmbeddedIds = (config) ->
  config and (config.embedded is "ids")
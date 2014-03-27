inflector = Ember.Inflector.inflector
inflector.irregular 'reportSettings', 'reportSettings'
inflector.irregular 'userSettings', 'userSettings'
inflector.irregular 'tenantSettings', 'tenantSettings'
inflector.irregular 'coreSettings', 'coreSettings'
inflector.irregular 'invoicingSettings', 'invoicingSettings'
inflector.irregular 'storageQuotasSettings', 'storageQuotasSettings'
inflector.irregular 'invoicingNumberingSettings', 'invoicingNumberingSettings'
inflector.irregular 'reminderSettings', 'reminderSettings'

###
  Main serializer for the application.

  @class ApplicationSerializer
  @extends Vosae.ApplicationSerializer
  @namespace Vosae
  @module Vosae
###

Vosae.ApplicationSerializer = DS.RESTSerializer.extend
  ###
    Parse `resource_uri` and returns `id`. This method is called when
    extracting `hasMany` & `belongsTo` relationships
  ###
  deurlify: (value) ->
    if typeof value is "string"
      return value.split("/").reverse()[1]
    value
  
  ###
    Build a complete `resource_uri` from `type` and `id` of a specific 
    record. This method is called when adding `hasMany` & `belongsTo`
  ###
  urlify: (type, id) ->
    url = type.toString().split('.')[1].decamelize()
    ["", Vosae.Config.API_NAMESPACE, url, id, ""].join("/")

  ###
    The `extract` method is used to deserialize payload data from the
    server. By default the `JSONSerializer` does not push the records
    into the store. However records that subclass `JSONSerializer`
    such as the `RESTSerializer` may push records into the store as
    part of the extract call.

    This method delegates to a more specific extract method based on
    the `requestType`.
    
    We need the requestType and the query object when extracting meta.

    @method extract
    @param {DS.Store} store
    @param {subclass of DS.Model} type
    @param {Object} payload
    @param {String or Number} id
    @param {String} requestType
    @param {String or Object} query the query in case of "findQuery" request
    @return {Object} json The deserialized payload
  ###
  extract: (store, type, payload, id, requestType, query) ->
    @extractMeta store, type, payload, requestType, query

    specificExtract = "extract" + requestType.charAt(0).toUpperCase() + requestType.substr(1)
    @[specificExtract](store, type, payload, id, requestType)

  ###
    Called when the server has returned a payload representing
    multiple records, such as in response to a `findAll` or `findQuery`.
    
    Here we transform the payload to match the ember-data conventions. 
    - Update the payload root : payload.objects -> payload.contacts for example.
    - Create fake ids to embedded `belongsTo` and `hasMany` objects. Sideload embedded 
    `belongsTo` and `hasMany`.

    @method extractArray
    @param {DS.Store} store
    @param {subclass of DS.Model} type
    @param {Object} payload
    @param {'findAll'|'findMany'|'findHasMany'|'findQuery'} requestType
    @returns {Array} The primary array that was returned in response to the original query.
  ###
  extractArray: (store, primaryType, payload) ->
    if primaryType in [Vosae.Timeline, Vosae.Notification]
      return @_super store, primaryType, payload
    
    # 1) Update the payload root according to the type
    root = @payloadRootForType primaryType, "extractArray"
    payload[root] = payload.objects  
    delete payload.objects
 
    # 2) Update payload, adds fake id to embedded relationship and sideload all embedded belongsTo and hasMany
    partials = payload[root]
    forEach partials, ((partial) ->
      updatePayloadWithEmbedded.call this, store, primaryType, payload, partial
      return
    ), this

    return @_super store, primaryType, payload

  ###
    Extract all meta from request
  ###
  extractMeta: (store, type, payload, requestType, query) ->
    if payload and payload.meta
      payload.meta.since = if payload.meta.offset? then payload.meta.offset + payload.meta.limit else 0
      payload.meta.totalCount = payload.meta.total_count
      delete payload.meta.total_count
      store.metaForType(type, payload.meta, requestType, query)
      delete payload.meta

  ###
    Called when the server has returned a payload representing
    a single record, such as in response to a `find` or `save`.
    
    Here we transform the payload to match the ember-data conventions. 
    - Update the payload root : payload -> payload.contact for example.
    - Create fake ids to embedded `belongsTo` and `hasMany` objects. Sideload embedded 
    `belongsTo` and `hasMany`.

    @method extractSingle
    @param {DS.Store} store
    @param {subclass of DS.Model} type
    @param {Object} payload
    @param {String} id
    @param {'find'|'createRecord'|'updateRecord'|'deleteRecord'} requestType
    @returns {Object} the primary response to the original request
  ###
  extractSingle: (store, type, payload, id, requestType) ->
    # 1) Update the payload root according to the type
    root = @payloadRootForType type, "extractSingle"
    object = payload
    payload = {}
    payload[root] = object  
    partial = payload[root]
  
    # 2) Update payload, adds fake id to embedded relationship and sideload all embedded belongsTo and hasMany
    updatePayloadWithEmbedded.call this, store, type, payload, partial

    @_super store, type, payload, id, requestType

  ###
    Converts camelCased attributes to underscored when serializing.

    @method keyForAttribute
    @param {String} attribute
    @return String
  ###
  keyForAttribute: (attr) ->
    Ember.String.decamelize(attr)

  ###
    Underscores relationship names and appends "_id" or "_ids" when serializing
    relationship keys.

    @method keyForRelationship
    @param {String} key
    @param {String} kind
    @return String
  ###
  keyForRelationship: (key, kind) ->
    Ember.String.decamelize(key)

  ###
    Returns the expected payload root for a specific type. Pluralize if method 
    is called by an extractArray.

    @method payloadRootForType
    @param {subclass of DS.Model} type
    @param {String} extractMethod, must be "extractArray" or "extractSing"
    @returns {String} The payload root for the type
  ###
  payloadRootForType: (type, extractMethod) ->
    payloadRoot = type.toString().split('.')[1].camelize()
    if extractMethod is "extractArray"
      return payloadRoot.pluralize()
    payloadRoot


  serialize: (record, options) ->
    json = {}
    promises = []
    finalizer = ->
      json

    if options and options.includeId
      id = record.get "id"
      json[@get("primaryKey")] = id if id

    # Serialize attributes
    record.eachAttribute ((key, attribute) ->
      @serializeAttribute record, json, key, attribute
      return
    ), this

    # Serialize relationship
    record.eachRelationship ((key, relationship) ->
      if relationship.kind is "belongsTo"
        promises.push @serializeBelongsTo(record, json, relationship)
      else if relationship.kind is "hasMany"
        promises.push @serializeHasMany(record, json, relationship)
      return
    ), this

    Ember.RSVP.all(promises).then finalizer

  ###
    Serialize `belongsTo` relationship when it is configured as an embedded object.

    @method serializeBelongsTo
    @param {DS.Model} record
    @param {Object} json
    @param relationship
  ###
  serializeBelongsTo: (record, json, relationship) ->
    attr = relationship.key
    config = @get("attrs")
    key = (if @keyForRelationship then @keyForRelationship(attr, "belongsTo") else attr)
    polymorphic = if relationship.options.polymorphic then true else false

    finalizer = ->
      return json

    # BelongsTo is not embedded
    if not config or not isEmbedded(config[attr])
      belongsTo = record.get attr
      
      # Async belongsTo need to get record instance with a resolver
      if relationship.options.async
        return Ember.RSVP.resolve(belongsTo).then (record) =>
          if Em.isNone record
            json[key] = null
          else
            json[key] = @urlify relationship.type, record.get "id"
        .then(finalizer)

      # Not async belongsTo don't need to get record with a resolvee
      else
        if Em.isNone belongsTo
          json[key] = null
        else
          json[key] = @urlify relationship.type, belongsTo.get "id"
    
    # BelongsTo is embedded
    else
      embeddedBelongsTo = record.get attr
      if Em.isNone embeddedBelongsTo
        json[key] = null
      else
        return Ember.RSVP.resolve(embeddedBelongsTo.serialize()).then (record) =>
          # If embeddedBelongsTo is polymorphic
          if polymorphic
            record["resource_type"] = embeddedBelongsTo.constructor.typeKey.decamelize()
          json[key] = record
        .then(finalizer)

    return

  ###
    Serialize `hasMany` relationship when it is configured as embedded objects.

    @method serializeHasMany
    @param {DS.Model} record
    @param {Object} json
    @param relationship
  ###
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
          json[key] = hasMany
          resolve()

    return

  ###
    We don't want any root key serialized into the JSON 

    @method serializeIntoHash
    @param {Object} hash
    @param {subclass of DS.Model} type
    @param {DS.Model} record
    @param {Object} options
  ###
  serializeIntoHash: (hash, type, record, options) ->
    @serialize(record, options).then (serialized) ->
      hash.object = serialized
      hash

  ###
    Serializes a polymorphic type as a fully capitalized model name.

    @method serializePolymorphicType
    @param {DS.Model} record
    @param {Object} json
    @param relationship
  ###
  serializePolymorphicType: (record, json, relationship) ->
    console.log "serializePolymorphicType"
    key = relationship.key
    belongsTo = record.get key
    if belongsTo
      key = @keyForAttribute key
      json["resource_type"] = belongsTo.constructor.typeKey.decamelize()


###
  All the following functions are used by the ApplicationSerializer
###

get = Ember.get
forEach = Ember.EnumerableUtils.forEach


# Checks config for embedded flag
isEmbedded = (config) ->
  config and (config.embedded is "always" or config.embedded is "load")

# Checks config for included ids flag
hasEmbeddedIds = (config) ->
  config and (config.embedded is "ids")

# Used to remove id (foreign key) when embedding
removeId = (key, json) ->
  idKey = key + "_id"
  delete json[idKey] if json.hasOwnProperty(idKey)
  return

# Chooses a relationship kind to branch which function is used to update payload
# does not change payload if attr is not embedded
updatePayloadWithEmbedded = (store, type, payload, partial) ->
  attrs = @get "attrs"    
  type.eachRelationship ((key, relationship) ->
    # Embedded relationship
    if attrs and isEmbedded(attrs[key])
      updatePayloadWithEmbeddedHasMany.call this, store, key, relationship, payload, partial if relationship.kind is "hasMany"
      updatePayloadWithEmbeddedBelongsTo.call this, store, key, relationship, payload, partial if relationship.kind is "belongsTo"
    # Traditionnal relationship
    else
      updatePayloadWithHasMany.call this, store, key, relationship, payload, partial if relationship.kind is "hasMany"
      updatePayloadWithBelongsTo.call this, store, key, relationship, payload, partial if relationship.kind is "belongsTo"
    return
  ), this
  return

# Handles `belongsTo` relationship, deurlify content
updatePayloadWithBelongsTo = (store, primaryType, relationship, payload, partial) ->
  serializer = store.serializerFor(relationship.type.typeKey)
  attribute = serializer.keyForAttribute(primaryType)

  url = partial[attribute]
  partial[attribute] = serializer.deurlify(url) if url

  return

# Handles `hasMany` relationship, deurlify content
updatePayloadWithHasMany = (store, primaryType, relationship, payload, partial) ->
  serializer = store.serializerFor(relationship.type.typeKey)
  attribute = serializer.keyForAttribute(primaryType)

  forEach partial[attribute], (url, i) ->
    partial[attribute][i] = serializer.deurlify(url)

  return

# Handles embedding for `hasMany` relationship
updatePayloadWithEmbeddedHasMany = (store, primaryType, relationship, payload, partial) ->
  serializer = store.serializerFor(relationship.type.typeKey)
  primaryKey = get(this, "primaryKey")
  attr = relationship.type.typeKey
  
  # Underscore forces the embedded records to be side loaded.
  # it is needed when main type === relationship.type
  embeddedTypeKey = "_" + Ember.String.pluralize(attr)
  expandedKey = @keyForRelationship(primaryType, relationship.kind)
  attribute = @keyForAttribute(primaryType)
  ids = []

  return  unless partial[attribute]
  payload[embeddedTypeKey] = payload[embeddedTypeKey] or []
  forEach partial[attribute], (data, i) ->
    # Generate fake id
    data[primaryKey] = Ember.uuid++
    embeddedType = store.modelFor(attr)
    updatePayloadWithEmbedded.call serializer, store, embeddedType, payload, data
    ids.push data[primaryKey]
    payload[embeddedTypeKey].push data
    return
  partial[expandedKey] = ids

  return

# Handles embedding for `belongsTo` relationship
updatePayloadWithEmbeddedBelongsTo = (store, primaryType, relationship, payload, partial) ->
  attrs = @get("attrs")
  if not attrs or not (isEmbedded(attrs[Ember.String.camelize(primaryType)]) or isEmbedded(attrs[primaryType]))
    return

  attr = relationship.type.typeKey
  serializer = store.serializerFor(relationship.type.typeKey)
  primaryKey = get(serializer, "primaryKey")
  embeddedTypeKey = Ember.String.pluralize(attr)
  expandedKey = serializer.keyForRelationship(primaryType, relationship.kind)
  attribute = serializer.keyForAttribute(primaryType)

  unless partial[attribute]
    return

  # Generate fake id
  partial[attribute].id = Ember.uuid++

  # For embedded belongsTo polymorphic
  if relationship.options.polymorphic
    type = partial[expandedKey].resource_type.camelize()
    embeddedTypeKey = type.pluralize()

    partial[expandedKey.camelize() + "Type"] = partial[expandedKey].resource_type.camelize()
    delete partial[expandedKey].resource_type

  payload[embeddedTypeKey] = payload[embeddedTypeKey] or []
  embeddedType = store.modelFor(relationship.type.typeKey)
  for key of partial
    if partial.hasOwnProperty(key) and key is attribute
      updatePayloadWithEmbedded.call serializer, store, embeddedType, payload, partial[key]

  # Need a reference to the parent so relationship works between both `belongsTo` records
  partial[attribute][relationship.parentType.typeKey] = partial.id

  # Need to move an embedded `belongsTo` object into a pluralized collection
  payload[embeddedTypeKey].push partial[attribute]

  # Replace the embedded `belongTo` object by his id
  partial[expandedKey] = partial[attribute].id

  return
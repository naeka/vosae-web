inflector = Ember.Inflector.inflector
inflector.irregular 'reportSettings', 'reportSettings'
inflector.irregular 'userSettings', 'userSettings'
inflector.irregular 'tenantSettings', 'tenantSettings'
inflector.irregular 'coreSettings', 'coreSettings'
inflector.irregular 'invoicingSettings', 'invoicingSettings'
inflector.irregular 'storageQuotasSettings', 'storageQuotasSettings'
inflector.irregular 'invoicingNumberingSettings', 'invoicingNumberingSettings'

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
    Extract all meta from request
  ###
  extractMeta: (store, type, payload) ->
    if payload and payload.meta
      payload.meta.since = if payload.meta.offset? then payload.meta.offset + payload.meta.limit else 0
      payload.meta.totalCount = payload.meta.total_count
      delete payload.meta.total_count
      store.metaForType(type, payload.meta)
      delete payload.meta
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

  payloadRootForType: (type) ->
    type.toString().split('.')[1].camelize().pluralize()

  ###
    Called when the server has returned a payload representing
    multiple records, such as in response to a `findAll` or `findQuery`.
    
    Here we transform the payload to match the ember-data conventions. 
    - Update the payload root : payload.objects -> payload.timelines for exemple.
    - Create fake ids to embedded `belongsTo` and `hasMany` objects.
    - Sideload embedded `belongsTo` and `hasMany`.

    @method extractArray
    @param {DS.Store} store
    @param {subclass of DS.Model} type
    @param {Object} payload
    @param {'findAll'|'findMany'|'findHasMany'|'findQuery'} requestType
    @returns {Array} The primary array that was returned in response to the original query.
  ###
  extractArray: (store, primaryType, payload) ->
    # 1) Update the payload root according to the type
    root = @payloadRootForType(primaryType)
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
  return unless attrs
  type.eachRelationship ((key, relationship) ->
    config = attrs[key]
    if isEmbedded(config)
      updatePayloadWithEmbeddedHasMany.call this, store, key, relationship, payload, partial if relationship.kind is "hasMany"
      updatePayloadWithEmbeddedBelongsTo.call this, store, key, relationship, payload, partial if relationship.kind is "belongsTo"
    return
  ), this
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
    data[primaryKey] = partial.id + "_" + attribute.decamelize() + "_" + i
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
  partial[attribute].id = partial.id + "_" + attribute.decamelize()

  # For embedded belongsTo polymorphic
  if relationship.options.polymorphic
    type = partial[expandedKey].resource_type.camelize()
    embeddedTypeKey = type.pluralize()

    partial[expandedKey.camelize() + "Type"] = partial[expandedKey].resource_type.camelize()
    delete partial[expandedKey].resource_type

  payload[embeddedTypeKey] = payload[embeddedTypeKey] or []
  embeddedType = store.modelFor(relationship.type.typeKey)
  for key of partial
    if partial.hasOwnProperty(key) and key.camelize() is attribute
      updatePayloadWithEmbedded.call serializer, store, embeddedType, payload, partial[key]

  id = partial[attribute].id

  # Need a reference to the parent so relationship works between both `belongsTo` records
  partial[attribute][relationship.parentType.typeKey] = partial.id

  # Need to move an embedded `belongsTo` object into a pluralized collection
  payload[embeddedTypeKey].push partial[attribute]

  # Replace the embedded `belongTo` object by his id
  partial[expandedKey] = id

  return
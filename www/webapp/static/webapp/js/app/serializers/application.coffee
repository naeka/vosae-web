inflector = Ember.Inflector.inflector
inflector.irregular 'reportSettings', 'reportSettings'
inflector.irregular 'userSettings', 'userSettings'
inflector.irregular 'tenantSettings', 'tenantSettings'
inflector.irregular 'coreSettings', 'coreSettings'
inflector.irregular 'invoicingSettings', 'invoicingSettings'
inflector.irregular 'storageQuotasSettings', 'storageQuotasSettings'
inflector.irregular 'invoicingNumberingSettings', 'invoicingNumberingSettings'

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
  extractMeta: (store, type, payload) ->
    if payload and payload.meta
      payload.meta.since = if payload.meta.offset? then payload.meta.offset + payload.meta.limit else 0
      payload.meta.totalCount = payload.meta.total_count
      delete payload.meta.total_count
      store.metaForType(type, payload.meta)
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

    return @_super store, type, payload, id, requestType

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

  ###
    Serialize `belongsTo` relationship when it is configured as an embedded object.

    This example of an author model belongs to a post model:

    ```js
    Post = DS.Model.extend({
      title:    DS.attr('string'),
      body:     DS.attr('string'),
      author:   DS.belongsTo('author')
    });

    Author = DS.Model.extend({
      name:     DS.attr('string'),
      post:     DS.belongsTo('post')
    });
    ```

    Use a custom (type) serializer for the post model to configure embedded author

    ```js
    App.PostSerializer = DS.RESTSerializer.extend(DS.EmbeddedMixin, {
      attrs: {
        author: {embedded: 'always'}
      }
    })
    ```

    A payload with an attribute configured for embedded records can serialize
    the records together under the root attribute's payload:

    ```js
    {
      "post": {
        "id": "1"
        "title": "Rails is omakase",
        "author": {
          "id": "2"
          "name": "dhh"
        }
      }
    }
    ```

    @method serializeBelongsTo
    @param {DS.Model} record
    @param {Object} json
    @param relationship
  ###
  serializeBelongsTo: (record, json, relationship) ->
    attr = relationship.key
    config = @get("attrs")

    if not config or not isEmbedded(config[attr])
      @_super record, json, relationship
      return

    key = @keyForAttribute(attr)
    embeddedRecord = record.get(attr)

    unless embeddedRecord
      json[key] = null
    else
      json[key] = embeddedRecord.serialize()
      id = embeddedRecord.get("id")
      json[key].id = id  if id
      parentKey = @keyForAttribute(relationship.parentType.typeKey)
      removeId parentKey, json[key] if parentKey
      delete json[key][parentKey]
    return

  ###
    Serialize `hasMany` relationship when it is configured as embedded objects.

    This example of a post model has many comments:

    ```js
    Post = DS.Model.extend({
      title:    DS.attr('string'),
      body:     DS.attr('string'),
      comments: DS.hasMany('comment')
    });

    Comment = DS.Model.extend({
      body:     DS.attr('string'),
      post:     DS.belongsTo('post')
    });
    ```

    Use a custom (type) serializer for the post model to configure embedded comments

    ```js
    App.PostSerializer = DS.RESTSerializer.extend(DS.EmbeddedMixin, {
      attrs: {
        comments: {embedded: 'always'}
      }
    })
    ```

    A payload with an attribute configured for embedded records can serialize
    the records together under the root attribute's payload:

    ```js
    {
      "post": {
        "id": "1"
        "title": "Rails is omakase",
        "body": "I want this for my ORM, I want that for my template language..."
        "comments": [{
          "id": "1",
          "body": "Rails is unagi"
        }, {
          "id": "2",
          "body": "Omakase O_o"
        }]
      }
    }
    ```

    To embed the ids for a related object (using a hasMany relationship):
    ```js
    App.PostSerializer = DS.RESTSerializer.extend(DS.EmbeddedMixin, {
      attrs: {
        comments: {embedded: 'ids'}
      }
    })
    ```

    ```js
    {
      "post": {
        "id": "1"
        "title": "Rails is omakase",
        "body": "I want this for my ORM, I want that for my template language..."
        "comments": ["1", "2"]
      }
    }
    ```

    @method serializeHasMany
    @param {DS.Model} record
    @param {Object} json
    @param relationship
  ###
  serializeHasMany: (record, json, relationship) ->
    attr = relationship.key
    config = @get("attrs")
    key = undefined
    if not config or (not isEmbedded(config[attr]) and not hasEmbeddedIds(config[attr]))
      @_super record, json, relationship
      return
    if hasEmbeddedIds(config[attr])
      key = @keyForRelationship(attr, relationship.kind)
      json[key] = get(record, attr).mapBy(get(this, "primaryKey"))
    else
      key = @keyForAttribute(attr)
      json[key] = get(record, attr).map((relation) ->
        data = relation.serialize()
        primaryKey = get(this, "primaryKey")
        data[primaryKey] = get(relation, primaryKey)
        delete data.id if data.id is null
        data
      , this)
    return


  ###
    Serializes a polymorphic type as a fully capitalized model name.

    @method serializePolymorphicType
    @param {DS.Model} record
    @param {Object} json
    @param relationship
  ###
  serializePolymorphicType: (record, json, relationship) ->
    key = relationship.key
    belongsTo = record.get key
    if belongsTo
      key = @keyForAttribute key
      json[key + "_type"] = Ember.String.capitalize belongsTo.constructor.typeKey


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
    if partial.hasOwnProperty(key) and key is attribute
      updatePayloadWithEmbedded.call serializer, store, embeddedType, payload, partial[key]

  id = partial[attribute].id

  # Need a reference to the parent so relationship works between both `belongsTo` records
  partial[attribute][relationship.parentType.typeKey] = partial.id

  # Need to move an embedded `belongsTo` object into a pluralized collection
  payload[embeddedTypeKey].push partial[attribute]

  # Replace the embedded `belongTo` object by his id
  partial[expandedKey] = id

  return
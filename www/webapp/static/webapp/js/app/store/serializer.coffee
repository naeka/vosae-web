###
  Main serializer for Vosae. Mainly used to convert 
  data between server semantics and application semantics.

  @class Serializer
  @extends DS.RESTSerializer
  @namespace Vosae
  @module Vosae
###

Vosae.Serializer = DS.RESTSerializer.extend

  rootForType: (type) ->
    if type.superclass == Vosae.Timeline
       type = Vosae.Timeline
    else if type.superclass == Vosae.Notification
       type = Vosae.Notification
    @_super(type)


  ###
    Parse `resource_uri` and returns `id`. This method 
    is called when extracting `hasMany` & `belongsTo` relationships
  ###
  deurlify: (value) ->
    if typeof value is "string"
      return value.split("/").reverse()[1]
    value

  ###
    Build a complete `resource_uri` from `type` and `id` of a specific 
    record. This method is called when adding `hasMany` & `belongsTo`
  ###
  getItemURL: (meta, id) ->
    url = @get("adapter").rootForType meta.type
    ["", Vosae.Config.API_NAMESPACE, url, id, ""].join("/")

  ###
    Can be optimize, should we have to custom this hooks ?
  ###
  addHasMany: (hash, record, key, relationship) ->
    type = record.constructor.toString()
    name = relationship.key
    serializedHasMany = []
    includeType = (relationship.options and relationship.options.polymorphic)
    
    manyArray = Ember.get(record, name)

    manyArray.forEach (record) =>
      unless Ember.isNone(record.get('id'))
        serializedHasMany.push @getItemURL(relationship, record.get('id')) 
      else
        serializedHasMany.push @serialize(record,
          includeId: true
          includeType: includeType
        )
    
    hash[key] = serializedHasMany

  addBelongsTo: (hash, record, key, relationship) ->
    type = record.constructor
    name = relationship.key
    value = null
    includeType = (relationship.options and relationship.options.polymorphic)

    if @embeddedType(type, name)
      if embeddedChild = Ember.get(record, name)
        value = @serialize(embeddedChild,
          includeId: true
          includeType: includeType
        )
      hash[key] = value
    else
      child = Ember.get(record, relationship.key)
      id = Ember.get(child, "id")
      if relationship.options and relationship.options.polymorphic and not Ember.isNone(id)
        @addBelongsToPolymorphic hash, key, id, child.constructor
      else
        hash[key] = @getItemURL(relationship, id) unless Ember.isNone(id)

  extractHasMany: (type, hash, key) ->
    value = hash[key]

    if value
      value.forEach (item, i, collection) =>
        collection[i] = @deurlify(item)
    value

  extractBelongsTo: (type, hash, key) ->
    value = hash[key]
    value = @deurlify(value) if value
    value

  extractSince: (meta) ->
    meta.next if meta

  extractValidationErrors: (type, errors) ->
    if errors['error']?
      return errors['error']
    return

  pluralize: (name) ->
    name

  keyForBelongsTo: (type, name) ->
    @keyForAttributeName(type, name)

  keyForHasMany: (type, name) ->
    @keyForAttributeName(type, name)

  keyForEmbeddedType: ->
    'resource_type'

  extractRecordRepresentation: (loader, type, data, shouldSideload) ->
    keyForEmbeddedType = @keyForEmbeddedType()
    if keyForEmbeddedType of data
      foundType = @typeFromAlias(data[keyForEmbeddedType])
      if foundType
        type = foundType
      delete data[keyForEmbeddedType]
    @_super(loader, type, data, shouldSideload)


###
  This serializer is used to transform `ReferencedDictField`
  An empty embedded `ReferencedDictField` returns {} ember-data
  expect null.

  @class InvoiceBaseSerializer
  @extends Vosae.Serializer
  @namespace Vosae
  @module Vosae
###

Vosae.InvoiceBaseSerializer = Vosae.Serializer.extend
  transformRelatedToRelationship: (data) ->
    resourceUri = data['related_to']
    if resourceUri? and typeof resourceUri is 'string'
      key = resourceUri.split("/").reverse()[2]
      data["related_#{key}"] = resourceUri
      delete data['related_to']
    return data

  extractRecordRepresentation: (loader, type, data, shouldSideload) ->
    # Field PDF
    if type is Vosae.InvoiceRevision
      if data['pdf'] and jQuery.isEmptyObject data['pdf']
        data['pdf'] = null
    # Field RelatedTo
    if data.hasOwnProperty 'related_to'
      data = @transformRelatedToRelationship(data)
    @_super(loader, type, data, shouldSideload)


###
  This is a custom serializer for model <Vosae.User>
  It helps us to transforms `specific_permissions`
  and `permissions` keys to make it useable.

  @class UserSerializer
  @extends Vosae.Serializer
  @namespace Vosae
  @module Vosae
###

Vosae.UserSerializer = Vosae.Serializer.extend
  
  ###
    This custom hooks from adapter help us to transforms
    `specific_permissions` & `permissions` strings array
    to make it useable for Emberjs
  ###
  extractRecordRepresentation: (loader, type, data, shouldSideload) ->
    if data['specific_permissions']
      array = []
      $.map data['specific_permissions'], (value, key) ->
        array.addObject(name: key, value: value)
      data['specific_permissions'] = array

    @_super(loader, type, data, shouldSideload)

  ###
    This custom hooks from adapter help us to transforms
    `specificPermissions` & `permissions` objects array
    to make it useable for API
  ###
  addHasMany: (hash, record, key, relationship) ->
    serializedHasMany = @_super(hash, record, key, relationship)

    switch key
      when 'specific_permissions'
        obj = {}  
        $.map serializedHasMany, (permission) ->
          obj[permission.name] = permission.value
        serializedHasMany = obj
    hash[key] = serializedHasMany
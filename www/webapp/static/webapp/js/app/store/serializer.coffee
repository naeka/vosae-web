# This is the main serializer of the application.
# Mainly used to convert data between server 
# semantics and application semantics

Vosae.Serializer = DS.RESTSerializer.extend

  rootForType: (type) ->
    if type.superclass == Vosae.Timeline
       type = Vosae.Timeline
    else if type.superclass == Vosae.Notification
       type = Vosae.Notification
    return @_super(type)


  # Parse `resource_uri` and returns `id`
  # This method is called when extracting
  # `hasMany` & `belongsTo` relationships

  deurlify: (value) ->
    if typeof value is "string"
      return value.split("/").reverse()[1]
    return value

  # Build a complete `resource_uri` from `type`
  # and `id` of a specific record. This method 
  # is called when adding `hasMany` & `belongsTo`

  getItemURL: (meta, id) ->
    url = Ember.get(@, "adapter").rootForType(meta.type)
    return ["", Ember.get(@, "namespace"), url, id, ""].join("/")

  # Can be optimize, should we have to custom this hooks ?
  addHasMany: (hash, record, key, relationship) ->
    type = record.constructor
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

    return value

  extractBelongsTo: (type, hash, key) ->
    value = hash[key]
    value = @deurlify(value) if value
    return value

  extractSince: (meta) ->
    return meta.next if meta

  extractValidationErrors: (type, errors) ->
    if errors['error']?
      return errors['error']
    return

  pluralize: (name) ->
    return name

  keyForBelongsTo: (type, name) ->
    return @keyForAttributeName(type, name)

  keyForHasMany: (type, name) ->
    return @keyForAttributeName(type, name)

  keyForEmbeddedType: ->
    return 'resource_type'

  extractRecordRepresentation: (loader, type, json, shouldSideload) ->
    keyForEmbeddedType = @keyForEmbeddedType()
    if keyForEmbeddedType of json
      foundType = @typeFromAlias(json[keyForEmbeddedType])
      if foundType
        type = foundType
      delete json[keyForEmbeddedType]
    @_super(loader, type, json, shouldSideload)


# This serializer is used to transform `ReferencedDictField`
# An empty embedded `ReferencedDictField` returns {} ember-data
# expect null
Vosae.InvoiceBaseSerializer = Vosae.Serializer.extend
  extractRecordRepresentation: (loader, type, json, shouldSideload) ->
    if type is Vosae.InvoiceRevision
      if json['pdf'] and jQuery.isEmptyObject json['pdf']
        json['pdf'] = null
    @_super(loader, type, json, shouldSideload)


# This is custom serializer for model <Vosae.User>
# It helps us to transforms specific permissions 
# and permissions to make it useable.

Vosae.UserSerializer = Vosae.Serializer.extend
  
  # This custom hooks from adapter help us to transforms
  # `specific_permissions` & `permissions` strings array
  # to make it useable for Emberjs

  extractRecordRepresentation: (loader, type, json, shouldSideload) ->
    if json['specific_permissions']
      array = []
      $.map json['specific_permissions'], (value, key) ->
        array.addObject(name: key, value: value)
      json['specific_permissions'] = array

    @_super(loader, type, json, shouldSideload)

  # This custom hooks from adapter help us to transforms
  # `specificPermissions` & `permissions` objects array
  # to make it useable for API

  addHasMany: (hash, record, key, relationship) ->
    serializedHasMany = @_super(hash, record, key, relationship)

    switch key
      when 'specific_permissions'
        obj = {}  
        $.map serializedHasMany, (permission) ->
          obj[permission.name] = permission.value
        serializedHasMany = obj

    hash[key] = serializedHasMany
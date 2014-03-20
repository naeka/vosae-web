Vosae.Store = DS.Store.extend
  ###
    Set metadata for a type. As long as we needs some computed properties
    we create an `Ember.Object` instance and set it as metadata for the
    type

    @method metaForType
    @param {String or subclass of DS.Model} type
    @param {Object} metadata
    @param {String} requestType (findAll, findQuery, ...)
    @param {String or Object} query '?offset=40&?limit=5'
  ###
  metaForType: (type, metadata, requestType, query) ->
    type = @modelFor type

    if requestType is "findQuery" and Em.typeOf query is "string"
      meta = @typeMapFor(type).metadata.get("queries").findBy('lastQuery', query)
    else
      meta = @typeMapFor(type).metadata

    # Set the new metadata for the type
    if meta then for prop of metadata
      meta.set prop, metadata[prop]

  ###
    Returns a map of IDs to client IDs for a given type. We overide this method 
    because we want the metadata propery to return an Ember.Object rather than 
    an empty dict {}.

    @method typeMapFor
    @param type
    @return {Object} typeMap
  ###
  typeMapFor: (type) ->
    typeMaps = @get "typeMaps"
    guid = Ember.guidFor(type)
    typeMap = typeMaps[guid]

    return typeMap if typeMap

    typeMap =
      idToRecord: {}
      records: []
      metadata: Em.Object.createWithMixins(Vosae.MetaMixin, {})
      type: type

    typeMaps[guid] = typeMap
    typeMap

  ###
    Returns the adapter for a given type. If type is polymorphic we return 
    the adapter of his superclass.

    @method adapterFor
    @private
    @param {subclass of DS.Model} type
    @returns DS.Adapter
  ###
  adapterFor: (type) ->
    superclass = type.superclass
    switch superclass
      when Vosae.Notification then type = Vosae.Notification
      when Vosae.Timeline then type = Vosae.Timeline
    
    @_super type

  ###
    Returns an instance of the serializer for a given type. For
    example, `serializerFor('person')` will return an instance of
    `App.PersonSerializer`.

    If no `App.PersonSerializer` is found, this method will look
    for an `App.ApplicationSerializer` (the default serializer for
    your entire application).

    If no `App.ApplicationSerializer` is found, it will fall back
    to an instance of `DS.JSONSerializer`. 

    If type is polymorphic we return the serializer of his superclass.

    @method serializerFor
    @private
    @param {String} type the record to serialize
    @return {DS.Serializer}
  ###
  serializerFor: (type) ->
    if type in Vosae.Utilities.TIMELINE_MODELS
      type = "timeline"
    else if type in Vosae.Utilities.NOTIFICATION_MODELS
      type = "notification"
    else if type in Vosae.Utilities.REGISTRATION_INFO_MODELS
      type = "registrationInfo"

    @_super type

# Create an instance
Vosae.Store.create()
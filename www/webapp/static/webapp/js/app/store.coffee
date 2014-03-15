Vosae.Store = DS.Store.extend
  ###
    Set metadata for a type. As long as we needs some computed properties
    we create an `Ember.Object` instance and set it as metadata for the
    type

    @method metaForType
    @param {String or subclass of DS.Model} type
    @param {Object} metadata
  ###
  metaForType: (type, metadata) ->
    type = @modelFor type

    # Set the new metadata for the type
    for prop of metadata
      @typeMapFor(type).metadata.set prop, metadata[prop]


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

# Create an instance
Vosae.Store.create()
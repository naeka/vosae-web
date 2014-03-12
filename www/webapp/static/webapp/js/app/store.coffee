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

    # Create an `Ember.Object` instance from the metadata object
    newMetadata = Em.Object.createWithMixins Vosae.MetaMixin, metadata

    # The first time, oldMetadata should be an empty object { } so we 
    # need to create an `Ember.Object` instance before merging the 
    # newMetadata and the oldMetadata.
    oldMetadata = @typeMapFor(type).metadata
    if Em.typeOf oldMetadata is "object"
      oldMetadata = Em.Object.createWithMixins Vosae.MetaMixin, oldMetadata

    # Set the new metadata for the type
    @typeMapFor(type).metadata = Ember.merge oldMetadata, newMetadata

Vosae.Store.create()
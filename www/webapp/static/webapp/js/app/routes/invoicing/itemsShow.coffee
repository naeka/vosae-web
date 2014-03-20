Vosae.ItemsShowRoute = Ember.Route.extend
  beforeModel: ->
    meta = @store.metadataFor "item"
    if !meta or !meta.get "hasBeenFetched"
      @store.find "item"

  model: ->
    @store.all "item"
Vosae.SettingsApiKeysRoute = Ember.Route.extend
  beforeModel: ->
    meta = @store.metadataFor "apiKey"
    if !meta or !meta.get "hasBeenFetched"
      @store.find "apiKey"

  model: ->
    @store.all('apiKey')

  setupController: (controller, model) ->
    controller.setProperties
      'content': model
      'newApiKey': @store.createRecord("apiKey")

  deactivate: ->
    model = @controller.get "newApiKey"
    model.rollback() if model
Vosae.SettingsApiKeysRoute = Ember.Route.extend
  model: ->
    Vosae.ApiKey.all()

  setupController: (controller, model) ->
    controller.setProperties
      'content': model
      'newApiKey': Vosae.ApiKey.createRecord()

  renderTemplate: ->
    @render 'settings.apiKeys',
      into: 'settings'
      outlet: 'content'

  deactivate: ->
    newApiKey = @controller.get 'newApiKey'
    if newApiKey.get 'isDirty'
      newApiKey.get('transaction').rollback()
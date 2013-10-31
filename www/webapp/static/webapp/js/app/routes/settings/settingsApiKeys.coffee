Vosae.SettingsApiKeysRoute = Ember.Route.extend
  beforeModel: ->
    if not Vosae.ApiKey.all().get('length')
      Vosae.ApiKey.find()

  model: ->
    Vosae.ApiKey.createRecord()

  setupController: (controller, model) ->
    transaction = @get('store').transaction()

    controller.setProperties
      'content': transaction.createRecord(Vosae.ApiKey)
      'apiKeys': Vosae.ApiKey.all()

  renderTemplate: ->
    @render 'settings.apiKeys',
      into: 'settings'
      outlet: 'content'
      controller: @controller

  deactivate: ->
    newApiKey = @controller.get 'content'
    if newApiKey.get 'isDirty'
      newApiKey.get('transaction').rollback()
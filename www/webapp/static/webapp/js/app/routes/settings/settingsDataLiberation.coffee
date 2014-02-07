Vosae.SettingsDataLiberationRoute = Ember.Route.extend
  model: ->
    # @get('session.tenantSettings')

  setupController: (controller, model) ->
    # controller.setProperties
      # 'content': model
      # 'currencies': Vosae.Currency.all().filterProperty('id')
      # 'paymentTypes': Vosae.paymentTypes

  renderTemplate: ->
    @render 'settings.dataLiberation',
      into: 'settings'
      outlet: 'content'
  
  deactivate: ->
    settingsDataLiberation = @controller.get 'content'
    if settingsDataLiberation.get 'isDirty'
      settingsDataLiberation.get("transaction").rollback()
Vosae.SettingsNumberingRoute = Ember.Route.extend
  model: ->
    @get('session.tenantSettings')

  setupController: (controller, model) ->
    controller.set('content', model)

  renderTemplate: ->
    @render 'settings.numbering',
      into: 'settings'
      outlet: 'content'
  
  deactivate: ->
    settingsCurrencies = @controller.get 'content'
    if settingsCurrencies.get 'isDirty'
      settingsCurrencies.get("transaction").rollback()
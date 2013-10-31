Vosae.SettingsInvoicingGeneralRoute = Ember.Route.extend
  model: ->
    @get('session.tenantSettings')

  setupController: (controller, model) ->
    controller.setProperties
      'content': model
      'currencies': Vosae.Currency.all().filterProperty('id')
      'paymentTypes': Vosae.paymentTypes

  renderTemplate: ->
    @render 'settings.invoicingGeneral',
      into: 'settings'
      outlet: 'content'

    @render 'settings.invoicingGeneral.actions',
      into: 'settings'
      outlet: 'actions'
      controller: @controller
  
  deactivate: ->
    settingsInvoicingGeneral = @controller.get 'content'
    if settingsInvoicingGeneral.get 'isDirty'
      settingsInvoicingGeneral.get("transaction").rollback()
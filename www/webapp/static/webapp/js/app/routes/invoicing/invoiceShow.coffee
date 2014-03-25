Vosae.InvoiceShowRoute = Ember.Route.extend
  model: ->
    @modelFor("invoice")

  setupController: (controller, model) ->
    controller.setProperties
      'content': model
      'currencies': @store.all('currency')
      'invoicingSettings': @get('session.tenantSettings.invoicing')
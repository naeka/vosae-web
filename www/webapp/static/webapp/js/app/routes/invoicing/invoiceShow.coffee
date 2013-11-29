Vosae.InvoiceShowRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.setProperties
      'content': @modelFor("invoice")
      'currencies': Vosae.Currency.all().filterProperty('id')
      'invoicingSettings': @get('session.tenantSettings.invoicing')
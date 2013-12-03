Vosae.QuotationShowRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.setProperties
      'content': @modelFor("quotation")
      'invoicingSettings': @get('session.tenantSettings.invoicing')
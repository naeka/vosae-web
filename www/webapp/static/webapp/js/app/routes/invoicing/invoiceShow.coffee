Vosae.InvoiceShowRoute = Ember.Route.extend
  model: ->
    @modelFor("invoice")

  setupController: (controller, model) ->
    controller.setProperties
      'content': model
      'invoicingSettings': @get('session.tenantSettings.invoicing')
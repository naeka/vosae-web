Vosae.PurchaseOrderShowRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.setProperties
      'content': @modelFor("purchaseOrder")
      'invoicingSettings': @get('session.tenantSettings.invoicing')
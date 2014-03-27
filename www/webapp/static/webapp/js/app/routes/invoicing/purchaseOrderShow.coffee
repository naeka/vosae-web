Vosae.PurchaseOrderShowRoute = Ember.Route.extend
  model: ->
    @modelFor("purchaseOrder")

  setupController: (controller, model) ->
    controller.setProperties
      'content': model
      'invoicingSettings': @get('session.tenantSettings.invoicing')
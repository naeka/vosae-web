Vosae.PurchaseOrderShowRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.setProperties
      'content': @modelFor("purchaseOrder")
      'invoicingSettings': @get('session.tenantSettings.invoicing')

  renderTemplate: ->
    @_super()
    @render 'purchaseOrder.show.settings',
      into: 'application'
      outlet: 'outletPageSettings'
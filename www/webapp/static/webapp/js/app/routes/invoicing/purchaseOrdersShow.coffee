Vosae.PurchaseOrdersShowRoute = Ember.Route.extend
  model: ->
    Vosae.PurchaseOrder.all()

  renderTemplate: ->
    @_super()
    @render 'purchaseOrders.show.settings',
      into: 'application'
      outlet: 'outletPageSettings'

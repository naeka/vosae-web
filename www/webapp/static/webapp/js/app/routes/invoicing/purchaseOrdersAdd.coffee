Vosae.PurchaseOrdersAddRoute = Vosae.QuotationsAddRoute.extend
  init: ->
    @_super()
    @get('container').register('controller:purchaseOrders.add', Vosae.PurchaseOrderEditController)

  model: ->
    Vosae.PurchaseOrder.createRecord()

  renderTemplate: ->
    @_super()
    @render 'purchaseOrder.edit.settings',
      into: 'application'
      outlet: 'outletPageSettings'
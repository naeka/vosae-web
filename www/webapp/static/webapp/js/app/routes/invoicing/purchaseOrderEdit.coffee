Vosae.PurchaseOrderEditRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.setProperties
      'content': @modelFor("purchaseOrder")
      'taxes': Vosae.Tax.all()
      'invoicingSettings': @get('session.tenantSettings.invoicing')

  renderTemplate: ->
    @_super()
    @render 'purchaseOrder.edit.settings',
      into: 'application'
      outlet: 'outletPageSettings'

  deactivate: ->
    purchaseOrder = @controller.get 'content'
    if purchaseOrder.get 'isDirty'
      purchaseOrder.get("transaction").rollback()
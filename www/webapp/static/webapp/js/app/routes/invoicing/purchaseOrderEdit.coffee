Vosae.PurchaseOrderEditRoute = Ember.Route.extend
  model: ->
    @modelFor("purchaseOrder")

  setupController: (controller, model) ->
    controller.setProperties
      'content': model
      'taxes': @store.all('tax')
      'invoicingSettings': @get('session.tenantSettings.invoicing')

  renderTemplate: ->
    @_super()
    @render 'purchaseOrder.edit.settings',
      into: 'tenant'
      outlet: 'outletPageSettings'

  deactivate: ->
    model = @controller.get "content"
    model.rollback() if model

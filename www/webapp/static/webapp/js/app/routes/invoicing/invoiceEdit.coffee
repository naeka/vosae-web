Vosae.InvoiceEditRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.setProperties
      'content': @modelFor("invoice")
      'taxes': Vosae.Tax.all()
      'invoicingSettings': @get('session.tenantSettings.invoicing')

  renderTemplate: ->
    @_super()
    @render 'invoice.edit.settings',
      into: 'application'
      outlet: 'outletPageSettings'

  deactivate: ->
    invoice = @controller.get 'content'
    if invoice.get 'isDirty'
      invoice.get("transaction").rollback()
Vosae.QuotationEditRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.setProperties
      'content': @modelFor("quotation")
      'taxes': Vosae.Tax.all()
      'invoicingSettings': @get('session.tenantSettings.invoicing')

  renderTemplate: ->
    @_super()
    @render 'quotation.edit.settings',
      into: 'application'
      outlet: 'outletPageSettings'

  deactivate: ->
    try
      quotation = @controller.get 'content'
      if quotation.get('currentRevision.currentState.stateName') is "root.loaded.updated.uncommitted"
        quotation.set 'currentRevision.currentState', DS.RootState.loaded.saved
      if quotation.get 'isDirty'
        quotation.get("transaction").rollback()

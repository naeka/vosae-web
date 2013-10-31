Vosae.QuotationShowRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.setProperties
      'content': @modelFor("quotation")
      'invoicingSettings': @get('session.tenantSettings.invoicing')

  renderTemplate: ->
    @_super()
    @render 'quotation.show.settings',
      into: 'application'
      outlet: 'outletPageSettings'
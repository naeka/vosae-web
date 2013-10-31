Vosae.InvoicingDashboardRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.get('controllers.quotationsShow').set('content', Vosae.Quotation.all())
    controller.get('controllers.invoicesShow').set('content', Vosae.Invoice.all())

  renderTemplate: ->
    @_super()
    @render 'invoicing.dashboard.settings',
      into: 'application'
      outlet: 'outletPageSettings'
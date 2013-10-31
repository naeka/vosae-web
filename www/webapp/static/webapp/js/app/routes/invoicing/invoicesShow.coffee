Vosae.InvoicesShowRoute = Ember.Route.extend
  model: ->
    Vosae.Invoice.all()

  renderTemplate: ->
    @_super()
    @render 'invoices.show.settings',
      into: 'application'
      outlet: 'outletPageSettings'
Vosae.QuotationsShowRoute = Ember.Route.extend
  model: ->
    Vosae.Quotation.all()

  renderTemplate: ->
    @_super()
    @render 'quotations.show.settings',
      into: 'application'
      outlet: 'outletPageSettings'

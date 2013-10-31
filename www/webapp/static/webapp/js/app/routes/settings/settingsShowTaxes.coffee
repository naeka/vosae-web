Vosae.SettingsShowTaxesRoute = Ember.Route.extend
  model: ->
    Vosae.Tax.all()

  renderTemplate: ->
    @render 'settings.showTaxes',
      into: 'settings'
      outlet: 'content'
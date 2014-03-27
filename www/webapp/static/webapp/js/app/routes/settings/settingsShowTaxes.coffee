Vosae.SettingsShowTaxesRoute = Ember.Route.extend
  model: ->
    @store.all("tax")
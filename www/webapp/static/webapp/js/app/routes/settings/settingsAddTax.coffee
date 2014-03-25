Vosae.SettingsAddTaxRoute = Ember.Route.extend
  controllerName: "settingsEditTax"

  model: ->
    @store.createRecord("tax")

  deactivate: ->
    model = @controller.get "content"
    model.rollback() if model
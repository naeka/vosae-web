Vosae.SettingsAddTaxRoute = Ember.Route.extend
  controllerName: "settingsEditTax"
  viewName: "settingsEditTax"
  templateName: "settings/editTax"

  model: ->
    @store.createRecord("tax")

  deactivate: ->
    model = @controller.get "content"
    model.rollback() if model
Vosae.SettingsEditTaxRoute = Ember.Route.extend
  deactivate: ->
    model = @controller.get "content"
    model.rollback() if model
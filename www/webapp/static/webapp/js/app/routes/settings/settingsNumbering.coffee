Vosae.SettingsNumberingRoute = Ember.Route.extend
  model: ->
    @get('session.tenantSettings')
  
  deactivate: ->
    model = @controller.get "content"
    model.rollback() if model
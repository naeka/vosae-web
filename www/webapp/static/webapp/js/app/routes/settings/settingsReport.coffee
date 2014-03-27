Vosae.SettingsReportRoute = Ember.Route.extend
  model: ->
    @get('session.tenant')
  
  deactivate: ->
    model = @controller.get "content"
    model.rollback() if model
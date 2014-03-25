Vosae.SettingsReportRoute = Ember.Route.extend
  model: ->
    @get('session.tenant.reportSettings')
  
  deactivate: ->
    model = @controller.get "content"
    model.rollback() if model
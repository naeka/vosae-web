Vosae.SettingsReportRoute = Ember.Route.extend
  model: ->
    @get('session.tenant.reportSettings')

  setupController: (controller, model) ->
    controller.set('content', model)

  renderTemplate: ->
    @render 'settings.report',
      into: 'settings'
      outlet: 'content'
  
  deactivate: ->
    reportSetting = @controller.get 'content'
    if reportSetting.get 'isDirty'
      reportSetting.get("transaction").rollback()
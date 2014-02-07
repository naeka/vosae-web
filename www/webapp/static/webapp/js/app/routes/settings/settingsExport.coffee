Vosae.SettingsExportRoute = Ember.Route.extend
  beforeModel: ->
    if not Vosae.Export.all().get('length')
      Vosae.Export.find()

  model: ->
    Vosae.Export.all()

  setupController: (controller, model) ->
    controller.setProperties
      'content': model
      'export': Vosae.Export.createRecord()

  renderTemplate: ->
    @render 'settings.export',
      into: 'settings'
      outlet: 'content'
  
  deactivate: ->
    settingsExport = @controller.get 'content'
    if settingsExport.get 'isDirty'
      settingsExport.get("transaction").rollback()
Vosae.SettingsAddUserRoute = Ember.Route.extend
  controllerName: "settingsEditUser"
  viewName: "settingsEditUser"
  templateName: "settings/editUser"

  model: ->
    @store.createRecord("user")

  setupController: (controller, model) ->
    model.set 'settings', @store.createRecord("userSettings")
    controller.setProperties
      'content': model
      'groupsList': @store.all("group")

  deactivate: ->
    model = @controller.get "content"
    model.rollback() if model

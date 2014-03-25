Vosae.SettingsAddUserRoute = Ember.Route.extend
  controllerName: "settingsEditUser"

  model: ->
    @store.createRecord("user")

  setupController: (controller, model) ->
    userSettings = @store.createRecord("userSettings")
    model.set 'settings', userSettings
    controller.setProperties
      'content': model
      'groupsList': @store.all("group")

  deactivate: ->
    model = @controller.get "content"
    model.rollback() if model
Vosae.SettingsAddGroupRoute = Ember.Route.extend
  controllerName: "settingsEditGroup"

  model: ->
    @store.createRecord("group")

  setupController: (controller, model) ->
    controller.setProperties
      'content': model
      'groupsList': @store.all("group")
      
  deactivate: ->
    model = @controller.get "content"
    model.rollback() if model
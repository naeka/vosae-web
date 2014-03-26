Vosae.SettingsEditGroupRoute = Ember.Route.extend
  setupController: (controller, model) ->
    groups = @store.all("group").filter (group) =>
      group if group.get('id') and group isnt model

    controller.setProperties
      'content': model
      'groupsList': groups

  deactivate: ->
    model = @controller.get "content"
    model.rollback() if model
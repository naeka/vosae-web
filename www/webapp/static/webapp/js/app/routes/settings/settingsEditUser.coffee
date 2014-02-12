Vosae.SettingsEditUserRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.set('content', model)
    controller.set('groupsList', Vosae.Group.all())

  renderTemplate: ->
    @render 'settings.editUser',
      into: 'settings'
      outlet: 'content'
  
  deactivate: ->
    user = @controller.get 'content'
    if user.get 'isDirty'
      user.get("transaction").rollback()
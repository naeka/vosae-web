Vosae.SettingsEditGroupRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.set('content', model)
    controller.set('groupsList', Vosae.Group.all())

  renderTemplate: ->
    @render 'settings.editGroup',
      into: 'settings'
      outlet: 'content'

  deactivate: ->
    group = @controller.get 'content'
    if group.get 'isDirty'
      group.get("transaction").rollback()
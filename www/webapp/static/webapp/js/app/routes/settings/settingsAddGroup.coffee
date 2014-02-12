Vosae.SettingsAddGroupRoute = Ember.Route.extend
  init: ->
    @_super()
    @get('container').register 'controller:settings.addGroup', Vosae.SettingsEditGroupController

  model: ->
    Vosae.Group.createRecord()

  setupController: (controller, model) ->
    controller.setProperties
      'content': model
      'groupsList': Vosae.Group.all()
      
  renderTemplate: ->
    @render 'settings.editGroup',
      into: 'settings'
      outlet: 'content'
      controller: @controller

  deactivate: ->
    group = @controller.get 'content'
    if group.get 'isDirty'
      group.get("transaction").rollback()
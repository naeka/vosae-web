Vosae.SettingsAddUserRoute = Ember.Route.extend
  init: ->
    @_super()
    @get('container').register('controller:settings.addUser', Vosae.SettingsEditUserController)

  model: ->
    Vosae.User.createRecord()

  setupController: (controller, model) ->
    unusedTransaction = @get('store').transaction()
    userSettings = unusedTransaction.createRecord(Vosae.UserSettings)
    model.set 'settings', userSettings
    controller.setProperties
      'content': model
      'unusedTransaction': unusedTransaction
      'groupsList': Vosae.Group.all()

  renderTemplate: ->
    @render 'settings.editUser',
      into: 'settings'
      outlet: 'content'
      controller: @controller

  deactivate: ->
    user = @controller.get 'content'
    if user.get 'isDirty'
      user.get("transaction").rollback()

    unusedTransaction = @controller.get 'unusedTransaction'
    if unusedTransaction
      unusedTransaction.rollback()
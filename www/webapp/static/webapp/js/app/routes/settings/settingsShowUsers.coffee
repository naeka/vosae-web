Vosae.SettingsShowUsersRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.set('content', Vosae.User.all())

  renderTemplate: ->
    @render 'settings.showUsers',
      into: 'settings'
      outlet: 'content'

Vosae.SettingsShowGroupsRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.set('content', Vosae.Group.all()) 

  renderTemplate: ->
    @render 'settings.showGroups',
      into: 'settings'
      outlet: 'content'
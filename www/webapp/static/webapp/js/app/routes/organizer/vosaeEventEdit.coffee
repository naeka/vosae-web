Vosae.VosaeEventEditRoute = Ember.Route.extend
  setupController: (controller, model) ->
    @controllerFor('calendarListsShow').set('model', Vosae.CalendarList.find())
    controller.setProperties
      'content': @modelFor("vosaeEvent")

  renderTemplate: ->
    @_super()
    @render 'vosaeEvent.edit.settings',
      into: 'application'
      outlet: 'outletPageSettings'
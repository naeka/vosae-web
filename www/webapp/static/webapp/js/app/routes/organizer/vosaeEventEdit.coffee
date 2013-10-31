Vosae.VosaeEventEditRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.setProperties
      'content': @modelFor("vosaeEvent")
      'calendarLists': Vosae.CalendarList.find()

  renderTemplate: ->
    @_super()
    @render 'vosaeEvent.edit.settings',
      into: 'application'
      outlet: 'outletPageSettings'
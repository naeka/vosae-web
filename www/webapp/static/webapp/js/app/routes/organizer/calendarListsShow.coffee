Vosae.CalendarListsShowRoute = Ember.Route.extend
  model: ->
    Vosae.CalendarList.find({})

  setupController: (controller, model) ->
    controller.get('controllers.calendarListsShowSettings').set 'content', model

  renderTemplate: ->
    @_super()
    @render 'calendarLists.show.settings',
      into: 'application'
      outlet: 'outletPageSettings'
      controller: 'calendarListsShowSettings'
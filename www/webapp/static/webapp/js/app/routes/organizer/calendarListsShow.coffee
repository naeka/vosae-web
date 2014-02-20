Vosae.CalendarListsShowRoute = Ember.Route.extend
  beforeModel: ->
    Vosae.CalendarList.all().then (calendarLists) ->
      Vosae.CalendarList.find() if calendarLists.get('length') == 0

  model: ->
    Vosae.CalendarList.all()

  setupController: (controller, model) ->
    controller.set 'content', model
    controller.get('controllers.calendarListsShowSettings').set 'content', model

  renderTemplate: ->
    @_super()
    @render 'calendarLists.show.settings',
      into: 'application'
      outlet: 'outletPageSettings'
      controller: 'calendarListsShowSettings'
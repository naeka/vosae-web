Vosae.CalendarListShowRoute = Ember.Route.extend
  model: ->
    @modelFor("calendarList")

  renderTemplate: ->
    @_super()
    @render 'calendarList.show.settings',
      into: 'tenant'
      outlet: 'outletPageSettings'
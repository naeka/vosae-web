Vosae.CalendarListShowRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.set 'content', @modelFor("calendarList")

  renderTemplate: ->
    @_super()
    @render 'calendarList.show.settings',
      into: 'application'
      outlet: 'outletPageSettings'
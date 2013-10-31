Vosae.CalendarListEditRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.set 'content', @modelFor("calendarList")

  renderTemplate: ->
    @_super()
    @render 'calendarList.edit.settings',
      into: 'application'
      outlet: 'outletPageSettings'
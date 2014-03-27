Vosae.CalendarListEditRoute = Ember.Route.extend
  model: ->
    @modelFor("calendarList")
  
  renderTemplate: ->
    @_super()
    @render 'calendarList.edit.settings',
      into: 'tenant'
      outlet: 'outletPageSettings'

  deactivate: ->
    model = @controller.get "content"
    model.rollback() if model
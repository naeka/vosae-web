Vosae.CalendarListsShowRoute = Ember.Route.extend
  beforeModel: ->
    meta = @store.metadataFor "calendarList"
    if !meta or !meta.get "hasBeenFetched"
      @store.find "calendarList"

  model: ->
    @store.all('calendarList')

  setupController: (controller, model) ->
    controller.set 'content', model
    controller.get('controllers.calendarListsShowSettings').set 'content', model

  renderTemplate: ->
    @_super()
    @render 'calendarLists.show.settings',
      into: 'tenant'
      outlet: 'outletPageSettings'
      controller: 'calendarListsShowSettings'
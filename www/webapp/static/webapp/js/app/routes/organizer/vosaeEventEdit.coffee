Vosae.VosaeEventEditRoute = Ember.Route.extend
  beforeModel: ->
    meta = @store.metadataFor "calendarList"
    if !meta or !meta.get "hasBeenFetched"
      @store.find "calendarList"

  model: ->
    calendarLists = @store.all('calendarList')
    vosaeEvent = @modelFor("vosaeEvent")
    Ember.RSVP.all [calendarLists, vosaeEvent]

  setupController: (controller, model) ->
    @controllerFor('calendarListsShow').set 'model', model[0]
    controller.set 'content', model[1]

  renderTemplate: ->
    @_super()
    @render 'vosaeEvent.edit.settings',
      into: 'tenant'
      outlet: 'outletPageSettings'
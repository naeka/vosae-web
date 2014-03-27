###
  Custom controller that manage real time data with pusher

  @class RealtimeController
  @extends Ember.ArrayController
  @namespace Vosae
  @module Vosae
###

Vosae.RealtimeController = Ember.Controller.extend
  pusher: null
  userChannel: null
  needs: ["dashboardIndex"]
  dashboardBinding: "controllers.dashboardIndex"

  initPusher: (->
    # Hack
    @get('store').modelFor('timeline')
    @get('store').modelFor('notification')

    # Pusher subscriptions
    @pusher = new Pusher Vosae.Config.PUSHER_KEY,
      cluster: Vosae.Config.PUSHER_CLUSTER
      authEndpoint: Vosae.Config.PUSHER_AUTH_ENDPOINT
      authTransport: 'jsonp'
    @userChannel = @pusher.subscribe Vosae.Config.PUSHER_USER_CHANNEL

    # Pusher notification binding
    @userChannel.bind 'new-notification', (data) =>
      @get('store').find(@getTypeKeyForResourceType(data.type), data.id).then (notification) ->
        notification.notifyPropertyChange('fixLazyLoadResource')

    # Pusher timeline binding
    @userChannel.bind 'new-timeline-entry', (data) =>
      @get('store').find(@getTypeKeyForResourceType(data.type), data.id).then (timeline) =>
        timeline.notifyPropertyChange('fixLazyLoadResource')        
        @get('dashboard').updateContentFrom(1, 2)

    # Pusher statistics binding
    @userChannel.bind 'statistics-update', (data) =>
      for statistics in data.statistics
        Vosae.lookup("controller:#{statistics}").fetchResults()
  ).on "init"

  ###
    Returns the type key for resource type (eg "contact_saved_te" -> "contactSavedTE")
  ###
  getTypeKeyForResourceType: (type) ->
    type.substring(0, type.length - 1).camelize() + "E"
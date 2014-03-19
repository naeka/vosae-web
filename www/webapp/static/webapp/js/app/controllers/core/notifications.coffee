###
  Custom array controller for a collection of <Vosae.Notification> based records.

  @class NotificationsController
  @extends Vosae.ArrayController
  @uses Vosae.TransitionToLazyResourceMixin
  @namespace Vosae
  @module Vosae
###

Vosae.NotificationsController = Vosae.ArrayController.extend Vosae.TransitionToLazyResourceMixin,
  relatedType: "notification"

  actions:
    ###
      Flag all notifications as read
    ###
    markAllAsRead: ->
      unreadNotifs = @get('content').filterProperty('read', false)
      unreadNotifs.invoke('save') if unreadNotifs

  fetchContent: (->
    meta = @store.metadataFor "notification"
    # Notification hasn't been fetched
    if !meta or !meta.get "hasBeenFetched"
      @store.findAll "notification"
      promises = []
      for model in Vosae.Utilities.NOTIFICATION_MODELS
        promises.push @store.all(model)
      Ember.RSVP.all(promises).then (notifications) =>
        @set 'unmergedContent', notifications
  ).on "init"

  mergedRecordArrays: (->
    notifications = []
    @get("unmergedContent").forEach (recordArray) ->
      notifications = notifications.concat recordArray.get("content").toArray()
    @set "content", notifications
  ).observes "unmergedContent.length", "unmergedContent.@each.length"
  
  ###
    Returns unread notifications
  ###
  unreadNotifications: (->
    @get("content").filter((notification) ->
      notification unless notification.get("read")
    ).sortBy("sentAt").reverse()
  ).property 'content', 'content.length', 'content.@each.read'

  ###
    Returns all notifications marked as read
  ###
  readNotifications: (->
    @get("content").filter((notification) ->
      notification if notification.get("read")
    ).sortBy("sentAt").reverse()
  ).property 'content', 'content.length', 'content.@each.read'

  ###
    Number of unread notifications
  ###
  unreadCounter: (->
    length = @get('content').filterProperty('read', false).get('length')
    if length > 99
      length = "99+"
    length
  ).property('content.length', 'content.@each.read')
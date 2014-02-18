###
  Custom array controller for a collection of <Vosae.Notification> based records.

  @class NotificationsController
  @extends Vosae.ArrayController
  @uses Vosae.TransitionToLazyResourceMixin
  @namespace Vosae
  @module Vosae
###

Vosae.NotificationsController = Vosae.ArrayController.extend Vosae.TransitionToLazyResourceMixin,
  
  setContent: (->
    @set('content', Vosae.Notification.all())
  ).on "init"

  ###
    Returns unread notifications
  ###
  unreadNotifications: (->
    @get("content").filter((notification) ->
      notification unless notification.get("read")
    ).sortBy("sentAt").reverse()
  ).property 'content', 'content.length', 'content.@each.read'

  ###
    Returns all notifications flaged as read
  ###
  readNotifications: (->
    @get("content").filter((notification) ->
      notification if notification.get("read")
    ).sortBy("sentAt").reverse()
  ).property 'content', 'content.length', 'content.@each.read'

  actions:
    ###
      Flag all notifications as read
    ###
    markAllAsRead: ->
      @get('content').filterProperty('read', false).forEach (notification) ->
        notification.markAsRead()

  ###
    Number of unread notifications
  ###
  unreadCounter: (->
    length = @get('content').filterProperty('read', false).get('length')
    if length > 99
      length = "99+"
    length
  ).property('content.length', 'content.@each.read')
###
  Custom array controller for a collection of `Vosae.CalendarList` records.

  @class CalendarListsShowController
  @extends Ember.ArrayController
  @namespace Vosae
  @module Vosae
###

Vosae.CalendarListsShowController = Em.ArrayController.extend
  needs: ['calendarListsShowSettings', 'quickAddEvent', 'calendarListsShow']
  fc: null
  lastView: null
  lastViewStart: null

  calendarListsLoaded: (->
    !@get('content').findProperty 'isLoaded', false
  ).property "content.@each.isLoaded"


###
  Custom controller for a `Vosae.VosaeEvent` record.

  @class QuickAddEventController
  @extends Ember.ObjectController
  @namespace Vosae
  @module Vosae
###

Vosae.QuickAddEventController = Em.ObjectController.extend
  actions:
    cancel: (vosaeEvent) ->
      vosaeEvent.rollback()

    edit: (vosaeEvent) ->
      @transitionToRoute 'vosaeEvent.edit', @get('session.tenant'), vosaeEvent

    save: (vosaeEvent) ->
      if vosaeEvent.get('isNew')
        message = gettext 'Your event has been successfully created'
      else
        message = gettext 'Your event has been successfully updated'
      vosaeEvent.save().then ->
        Vosae.SuccessPopup.open
          message: message


###
  Custom array controller for a collection of `Vosae.CalendarList` records.

  @class CalendarListsShowSettingsController
  @extends Ember.ArrayController
  @namespace Vosae
  @module Vosae
###

Vosae.CalendarListsShowSettingsController = Em.ArrayController.extend
  needs: ['calendarListsShow']
  fcRendered: false

  actions:
    toggleCalendar: (elem, calendarList)->
      isSelected = !calendarList.get 'selected'
      calendarList.set 'selected', isSelected
      @get('store').commit()

      if isSelected
        @get('controllers.calendarListsShow').get('fc').fullCalendar 'addEventSource', calendarList.get('source')
      else
        @get('controllers.calendarListsShow').get('fc').fullCalendar 'removeEventSource', calendarList.get('source')

  initEventSources: (->
    if Em.isEmpty(@get('content').filterProperty('isLoaded', false)) and @get('fcRendered')
      @get('content').forEach (calendarList) =>
        if calendarList.get('selected')
          @get('controllers.calendarListsShow').get('fc').fullCalendar 'addEventSource', calendarList.get('source')
  ).observes('content.@each.isLoaded', 'fcRendered')

  ownCalendarList: (->
    @get('content').filterProperty('isOwn', true)
  ).property('content.length', 'content.@each.isOwn')

  sharedCalendarList: (->
    @get('content').filterProperty('isOwn', false)
  ).property('content.length', 'content.@each.isOwn')

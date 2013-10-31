Vosae.CalendarListsShowController = Em.ArrayController.extend
  fc: null
  lastView: null
  lastViewStart: null

  init: ->
    @_super()
    @get('needs').addObjects(['calendarListsShowSettings', 'quickAddEvent'])


Vosae.QuickAddEventController = Em.ObjectController.extend
  cancel: (vosaeEvent) ->
    if vosaeEvent
      vosaeEvent.get('transaction').rollback()

  edit: (vosaeEvent) ->
    @transitionToRoute 'vosaeEvent.edit', @get('session.tenant'), vosaeEvent

  save: (vosaeEvent) ->
    event = if vosaeEvent.get('id') then 'didUpdate' else 'didCreate'
    vosaeEvent.one event, @, ->
      Ember.run.next @, ->
        if event is 'didCreate'
          message = gettext 'Your event has been successfully created'
        else
          message = gettext 'Your event has been successfully updated'
        Vosae.SuccessPopupComponent.open
          message: message
    vosaeEvent.get('transaction').commit()


Vosae.CalendarListsShowSettingsController = Em.ArrayController.extend
  fcRendered: false

  init: ->
    @_super()
    @get('needs').addObject('calendarListsShow')

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

  toggleCalendar: (elem, calendarList)->
    isSelected = !calendarList.get 'selected'
    calendarList.set 'selected', isSelected
    @get('store').commit()

    if isSelected
      @get('controllers.calendarListsShow').get('fc').fullCalendar 'addEventSource', calendarList.get('source')
    else
      @get('controllers.calendarListsShow').get('fc').fullCalendar 'removeEventSource', calendarList.get('source')

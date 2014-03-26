###
  A data model that represents a calendar list

  @class CalendarList
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.CalendarList = Vosae.Model.extend
  summary: DS.attr('string')
  description: DS.attr('string')
  location: DS.attr('string')
  timezone: DS.attr('string')
  summaryOverride: DS.attr('string')
  color: DS.attr('string')
  selected: DS.attr('boolean', defaultValue: true)
  isOwn: DS.attr('boolean', defaultValue: true)
  calendar: DS.belongsTo('vosaeCalendar')
  reminders: DS.hasMany('reminderEntry')

  displayName: (->
    # Returns summary or summaryOverride in case of user overrided it
    if @get 'summaryOverride'
      return @get 'summaryOverride'
    @get 'summary'
  ).property 'summary', 'summaryOverride'

  displayColor: (->
    # Returns a formated `color`
    if @get 'color'
      return Vosae.Config.calendarListColors.findProperty('value', @get('color')).get('displayName')
    ''
  ).property 'color'

  displayTimezone: (->
    # Returns a formated `timezone`
    if @get 'timezone'
      return Vosae.Timezones.findProperty('value', @get('timezone')).get('displayName')
    ''
  ).property('timezone')

  textColor: (->
    # Returns a text color suitable for a background color
    if @get('color') and Color(@get('color')).luminosity() < 0.5
      return '#FEFEFE'
    '#333'
  ).property('color')

  source: (->
    source =
      events: (start, end, callback) =>
        # Filter by start, end and calendar
        query = 'start__gte=' + $.fullCalendar.formatDate(start, 'u')
        query += '&end__lt=' + $.fullCalendar.formatDate(end, 'u')
        query += '&calendar=' + @get('calendar.id')
        query += '&limit=' + 100
        @get('store').findQuery('vosaeEvent', query).then (events) =>
          callback @makeFcEvents(events)
      color: =>
        @get('color')
      textColor: =>
        @get('textColor')
  ).property()

  makeFcEvents: (events)->
    fc_events = []
    events.forEach (event)->
      fc_events.push event.getFullCalendarEvent()
    fc_events
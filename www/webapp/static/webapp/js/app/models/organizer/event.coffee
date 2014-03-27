###
  A data model that represents an event

  @class VosaeEvent
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.VosaeEvent = Vosae.Model.extend
  status: DS.attr('string')
  createdAt: DS.attr('datetime')
  updatedAt: DS.attr('datetime')
  summary: DS.attr('string')
  description: DS.attr('string')
  location: DS.attr('string')
  color: DS.attr('string')
  start: DS.belongsTo('eventDateTime')
  end: DS.belongsTo('eventDateTime')
  recurrence: DS.attr('string')
  originalStart: DS.belongsTo('eventDateTime')
  instanceId: DS.attr('string')
  transparency: DS.attr('string')
  calendar: DS.belongsTo('vosaeCalendar')
  calendarList: DS.belongsTo('calendarList')
  creator: DS.belongsTo('user')
  organizer: DS.belongsTo('user')
  attendees: DS.hasMany('attendee')
  reminders: DS.belongsTo('reminderSettings')

  allDay: ((key, value)->
    if arguments.length is 1
      if @get('start.allDay') and @get('end.allDay')
        return true
      return false
    else
      Em.assert('allDay must be a boolean', value instanceof Boolean or typeof value is 'boolean')
      @set('start.allDay', value)
      @set('end.allDay', value)
      value
  ).property('start', 'end')

  displayDate: (->
    if @get('start') and @get('end')
      format_opts =
        showDayOfWeek: true
        monthFormat: 'MMMM'
        weekdayFormat: 'dddd'
      if @get('allDay')
        return moment.twix(@get('start.date'), @get('end.date'), true).format(format_opts)
      moment.twix(@get('start.datetime'), @get('end.datetime')).format(format_opts)
  ).property('start', 'start.allDay', 'end', 'end.allDay')

  textColor: (->
    if @get('color') and Color(@get('color')).luminosity() < 0.5
      return '#FEFEFE'
    '#333'
  ).property('color')

  getFullCalendarEvent: ->
    ev =
      id: @get('id')
      title: @get('summary')
      start: @get('start.dateOrDatetime')
      end: @get('end.dateOrDatetime')
      allDay: @get('allDay')
    if @get('color')
      $.extend ev,
        color: @get('color')
        textColor: @get('textColor')
    ev
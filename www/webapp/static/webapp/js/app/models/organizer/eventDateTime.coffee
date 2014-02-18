###
  A data model that represents an event date time

  @class EventDateTime
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.EventDateTime = Vosae.Model.extend
  date: DS.attr('date')
  datetime: DS.attr('datetime')
  timezone: DS.attr('string')

  allDay: ((key, value) ->
    if arguments.length is 1
      if @get('date')
        return true
      return false
    else
      Em.assert('Value should be a boolean', value instanceof Boolean or typeof value == 'boolean')
      if value
        if @get('datetime') and not @get('date')
          @set 'date', moment(@get('datetime')).startOf('day').toDate()
          @set 'datetime', null
      else
        if @get('date') and not @get('datetime')
          @set 'datetime', @get('date')
          @set 'date', null
      value
  ).property('date', 'datetime')

  dateOrDatetime: ((key, value) ->
    if arguments.length is 1
      if @get 'allDay'
        return @get 'date'
      else
        return (if @get('datetime') then @get('datetime') else undefined)
    else
      Em.assert('Value should be a date', value instanceof Date)
      if @get 'allDay'
        value = moment(value).startOf('day').toDate()
        @set 'date', value
        @set 'datetime', null
      else
        @set 'date', null
        @set 'datetime', value
      value
  ).property('date', 'datetime')

  onlyDate: ((key, value) ->
    if arguments.length is 1
      throw new Error("The onlyDate property must only be used to set the date")
    else
      Em.assert('Value should be a date', value instanceof Date)
      dt = if @get('dateOrDatetime') then moment @get('dateOrDatetime') else moment new Date(null)
      dt.date value.getDate()
      dt.month value.getMonth()
      dt.year value.getFullYear()
      @set 'dateOrDatetime', dt.toDate()
  ).property('dateOrDatetime')

  onlyTime: ((key, value) ->
    if arguments.length is 1
      throw new Error("The onlyTime property must only be used to set the time")
    else
      Em.assert('Value should be a date', value instanceof Date)
      dt = if @get('dateOrDatetime') then moment @get('dateOrDatetime') else moment new Date(null)
      dt.hour value.getHours()
      dt.minute value.getMinutes()
      @set 'dateOrDatetime', dt.toDate()
  ).property('dateOrDatetime')

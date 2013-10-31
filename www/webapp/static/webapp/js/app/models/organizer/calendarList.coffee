Vosae.CalendarList = DS.Model.extend
  summary: DS.attr('string')
  description: DS.attr('string')
  location: DS.attr('string')
  timezone: DS.attr('string')
  summaryOverride: DS.attr('string')
  color: DS.attr('string')
  selected: DS.attr('boolean', defaultValue: true)
  isOwn: DS.attr('boolean', defaultValue: true)
  calendar: DS.belongsTo('Vosae.VosaeCalendar')
  reminders: DS.hasMany('Vosae.ReminderEntry')

  displayName: (->
    # Returns summary or summaryOverride in case of user overrided it
    if @get 'summaryOverride'
      return @get 'summaryOverride'
    @get 'summary'
  ).property 'summary', 'summaryOverride'

  displayColor: (->
    # Returns a formated `color`
    if @get 'color'
      return Vosae.calendarListColors.findProperty('value', @get('color')).get('displayName')
    ''
  ).property 'color'

  displayTimezone: (->
    # Returns a formated `timezone`
    if @get 'timezone'
      return Vosae.timezones.findProperty('value', @get('timezone')).get('displayName')
    ''
  ).property('timezone')

  textColor: (->
    # Returns a text color suitable for a background color
    if @get('color') and Color(@get('color')).luminosity() < 0.5
      return '#FEFEFE'
    '#333'
  ).property('color')

  source: (->
    self = @
    source =
      events: (start, end, callback)->
        # Filter by start, end and calendar
        events = Vosae.VosaeEvent.find
          start__gte: $.fullCalendar.formatDate(start, 'u')
          end__lt: $.fullCalendar.formatDate(end, 'u')
          calendar: self.get('calendar.id')
          limit: 100
        events.one 'didLoad', @, ->
          Em.run.next ->
            callback self.makeFcEvents(events)
      color: ->
        self.get('color')
      textColor: ->
        self.get('textColor')
    source
  ).property()

  makeFcEvents: (events)->
    fc_events = []
    events.forEach (event)->
      fc_events.push event.getFullCalendarEvent()
    fc_events

Vosae.Adapter.map "Vosae.CalendarList",
  reminders:
    embedded: "always"
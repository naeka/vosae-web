store = null

describe 'Vosae.VosaeEvent', ->
  hashEvent = 
    attendees: []
    color: null
    description: null
    end: null
    instance_id: null
    location: null
    original_start: null
    recurrence: null
    reminders: null
    start: null
    status: null
    summary: null
    transparency: null

  beforeEach ->
    comp = getAdapterForTest(Vosae.VosaeEvent)
    ajaxUrl = comp[0]
    ajaxType = comp[1]
    ajaxHash = comp[2]
    store = comp[3]

  afterEach ->
    comp = undefined
    ajaxUrl = undefined
    ajaxType = undefined
    ajaxHash = undefined
    store.destroy()

  it 'finding all vosaeEvent makes a GET to /vosae_event/', ->
    # Setup
    vosaeEvents = store.find Vosae.VosaeEvent
    
    # Test
    enabledFlags vosaeEvents, ['isLoaded', 'isValid'], recordArrayFlags
    expectAjaxURL "/vosae_event/"
    expectAjaxType "GET"

    # Setup
    ajaxHash.success(
      meta: {}
      objects: [$.extend({}, hashEvent, {id: 1, summary: "My vosaeEvent"})]
    )
    vosaeEvent = vosaeEvents.objectAt(0)

    # Test
    statesEqual vosaeEvents, 'loaded.saved'
    stateEquals vosaeEvent, 'loaded.saved'
    enabledFlagsForArray vosaeEvents, ['isLoaded', 'isValid']
    enabledFlags vosaeEvent, ['isLoaded', 'isValid']
    expect(vosaeEvent).toEqual store.find(Vosae.VosaeEvent, 1)

  it 'finding a vosaeEvent by ID makes a GET to /vosae_event/:id/', ->
    # Setup
    vosaeEvent = store.find Vosae.VosaeEvent, 1

    # Test
    stateEquals vosaeEvent, 'loading'
    enabledFlags vosaeEvent, ['isLoading', 'isValid']
    expectAjaxType "GET"
    expectAjaxURL "/vosae_event/1/"

    # Setup
    ajaxHash.success($.extend {}, hashEvent,
      id: 1
      summary: "My vosaeEvent"
    )

    # Test
    stateEquals vosaeEvent, 'loaded.saved'
    enabledFlags vosaeEvent, ['isLoaded', 'isValid']
    expect(vosaeEvent).toEqual store.find(Vosae.VosaeEvent, 1)

  it 'finding vosaeEvents by query makes a GET to /vosae_event/:query/', ->
    # Setup
    vosaeEvents = store.find Vosae.VosaeEvent, {page: 1}

    # Test
    expect(vosaeEvents.get('length')).toEqual 0
    enabledFlags vosaeEvents, ['isLoading'], recordArrayFlags
    expectAjaxURL "/vosae_event/"
    expectAjaxType "GET"
    expectAjaxData({page: 1 })

    # Setup
    ajaxHash.success(
      meta: {}
      objects: [
        $.extend {}, hashEvent, {id: 1, summary: "My vosaeEvent 1"}
        $.extend {}, hashEvent, {id: 2, summary: "My vosaeEvent 2"}
      ]
    )
    vosaeEvent1 = vosaeEvents.objectAt 0
    vosaeEvent2 = vosaeEvents.objectAt 1

    # Test
    statesEqual [vosaeEvent1, vosaeEvent2], 'loaded.saved'
    enabledFlags vosaeEvents, ['isLoaded'], recordArrayFlags
    enabledFlagsForArray [vosaeEvent1, vosaeEvent2], ['isLoaded'], recordArrayFlags
    expect(vosaeEvents.get('length')).toEqual 2
    expect(vosaeEvent1.get('summary')).toEqual "My vosaeEvent 1"
    expect(vosaeEvent2.get('summary')).toEqual "My vosaeEvent 2"
    expect(vosaeEvent1.get('id')).toEqual "1"
    expect(vosaeEvent2.get('id')).toEqual "2"

  it 'creating a vosaeEvent makes a POST to /vosae_event/', ->
    # Setup
    vosaeEvent = store.createRecord Vosae.VosaeEvent, {summary: "My vosaeEvent"}

    # Test
    stateEquals vosaeEvent, 'loaded.created.uncommitted'
    enabledFlags vosaeEvent, ['isLoaded', 'isDirty', 'isNew', 'isValid']

    # Setup
    vosaeEvent.get('transaction').commit()

    # Test
    stateEquals vosaeEvent, 'loaded.created.inFlight'
    enabledFlags vosaeEvent, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']
    expectAjaxURL "/vosae_event/"
    expectAjaxType "POST"
    expectAjaxData($.extend {}, hashEvent, {summary: "My vosaeEvent"})

    # Setup
    ajaxHash.success($.extend {}, hashEvent,
      id: 1
      summary: "My vosaeEvent"
      resource_uri: "/api/v1/vosae_event/1/"
    )

    # Test
    stateEquals vosaeEvent, 'loaded.saved'
    enabledFlags vosaeEvent, ['isLoaded', 'isValid']
    expect(vosaeEvent).toEqual store.find(Vosae.VosaeEvent, 1)

  it 'updating a vosaeEvent makes a PUT to /vosae_event/:id/', ->
    # Setup
    store.load Vosae.VosaeEvent,
      id: 1
      summary: "My vosaeEvent"
    vosaeEvent = store.find Vosae.VosaeEvent, 1

    # Test
    stateEquals vosaeEvent, 'loaded.saved' 
    enabledFlags vosaeEvent, ['isLoaded', 'isValid']

    # Setup
    vosaeEvent.setProperties {summary: "My vosaeEvent edited"}

    # Test
    stateEquals vosaeEvent, 'loaded.updated.uncommitted'
    enabledFlags vosaeEvent, ['isLoaded', 'isDirty', 'isValid']

    # Setup
    vosaeEvent.get('transaction').commit()

    # Test
    stateEquals vosaeEvent, 'loaded.updated.inFlight'
    enabledFlags vosaeEvent, ['isLoaded', 'isDirty', 'isSaving', 'isValid']
    expectAjaxURL "/vosae_event/1/"
    expectAjaxType "PUT"
    expectAjaxData($.extend {}, hashEvent,
      summary: "My vosaeEvent edited"
    )

    # Setup
    ajaxHash.success($.extend {}, hashEvent,
      id: 1
      summary: "My vosaeEvent edited"
    )

    # Test
    stateEquals vosaeEvent, 'loaded.saved'
    enabledFlags vosaeEvent, ['isLoaded', 'isValid']
    expect(vosaeEvent).toEqual store.find(Vosae.VosaeEvent, 1)
    expect(vosaeEvent.get('summary')).toEqual 'My vosaeEvent edited'

  it 'deleting a vosaeEvent makes a DELETE to /vosae_event/:id/', ->
    # Setup
    store.load Vosae.VosaeEvent, {id: 1}
    vosaeEvent = store.find Vosae.VosaeEvent, 1

    # Test
    stateEquals vosaeEvent, 'loaded.saved' 
    enabledFlags vosaeEvent, ['isLoaded', 'isValid']

    # Setup
    vosaeEvent.deleteRecord()

    # Test
    stateEquals vosaeEvent, 'deleted.uncommitted'
    enabledFlags vosaeEvent, ['isLoaded', 'isDirty', 'isDeleted', 'isValid']

    # Setup
    vosaeEvent.get('transaction').commit()

    # Test
    stateEquals vosaeEvent, 'deleted.inFlight'
    enabledFlags vosaeEvent, ['isLoaded', 'isDirty', 'isSaving', 'isDeleted', 'isValid']
    expectAjaxURL "/vosae_event/1/"
    expectAjaxType "DELETE"

    # Setup
    ajaxHash.success()

    # Test
    stateEquals vosaeEvent, 'deleted.saved'
    enabledFlags vosaeEvent, ['isLoaded', 'isDeleted', 'isValid']

  it 'start embedded belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.VosaeEvent).load store, Vosae.VosaeEvent, {id: 1, start: {timezone: "UTC"}}
    vosaeEvent = store.find Vosae.VosaeEvent, 1

    # Test
    expect(vosaeEvent.get('start.timezone')).toEqual "UTC"

  it 'end embedded belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.VosaeEvent).load store, Vosae.VosaeEvent, {id: 1, end: {timezone: "UTC"}}
    vosaeEvent = store.find Vosae.VosaeEvent, 1

    # Test
    expect(vosaeEvent.get('end.timezone')).toEqual "UTC"

  it 'originalStart embedded belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.VosaeEvent).load store, Vosae.VosaeEvent, {id: 1, original_start: {timezone: "UTC"}}
    vosaeEvent = store.find Vosae.VosaeEvent, 1

    # Test
    expect(vosaeEvent.get('originalStart.timezone')).toEqual "UTC"

  it 'calendar belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.VosaeCalendar).load store, Vosae.VosaeCalendar, {id: 1}
    store.adapterForType(Vosae.VosaeEvent).load store, Vosae.VosaeEvent, {id: 1, calendar: "/api/v1/vosae_calendar/1/"}
    calendar = store.find Vosae.VosaeCalendar, 1
    vosaeEvent = store.find Vosae.VosaeEvent, 1

    # Test
    expect(vosaeEvent.get('calendar')).toEqual calendar

  it 'calendarList belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.CalendarList).load store, Vosae.CalendarList, {id: 1}
    store.adapterForType(Vosae.VosaeEvent).load store, Vosae.VosaeEvent, {id: 1, calendar_list: "/api/v1/calendar_list/1/"}
    calendarList = store.find Vosae.CalendarList, 1
    vosaeEvent = store.find Vosae.VosaeEvent, 1

    # Test
    expect(vosaeEvent.get('calendarList')).toEqual calendarList

  it 'creator belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.User).load store, Vosae.User, {id: 1}
    store.adapterForType(Vosae.VosaeEvent).load store, Vosae.VosaeEvent, {id: 1, creator: "/api/v1/user/1/"}
    creator = store.find Vosae.User, 1
    vosaeEvent = store.find Vosae.VosaeEvent, 1

    # Test
    expect(vosaeEvent.get('creator')).toEqual creator

  it 'organizer belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.User).load store, Vosae.User, {id: 1}
    store.adapterForType(Vosae.VosaeEvent).load store, Vosae.VosaeEvent, {id: 1, organizer: "/api/v1/user/1/"}
    organizer = store.find Vosae.User, 1
    vosaeEvent = store.find Vosae.VosaeEvent, 1

    # Test
    expect(vosaeEvent.get('organizer')).toEqual organizer

  it 'attendees embedded hasMany relationship', ->
    # Setup
    store.adapterForType(Vosae.VosaeEvent).load store, Vosae.VosaeEvent,
      id:1
      attendees: [
        {email: "test@vosae.com"}
      ]
    vosaeEvent = store.find Vosae.VosaeEvent, 1

    # Test
    expect(vosaeEvent.get('attendees.firstObject.email')).toEqual "test@vosae.com"

  it 'reminders embedded belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.VosaeEvent).load store, Vosae.VosaeEvent,
      id:1
      reminders: {use_default: true}
    vosaeEvent = store.find Vosae.VosaeEvent, 1

    # Test
    expect(vosaeEvent.get('reminders.useDefault')).toEqual true

  it 'allDay property getter/setter', ->
    # Setup
    store.adapterForType(Vosae.VosaeEvent).load store, Vosae.VosaeEvent, {id: 1}
    vosaeEvent = store.find Vosae.VosaeEvent, 1

    # Test
    expect(vosaeEvent.get('allDay')).toBeFalsy()

    # Setup
    vosaeEvent.set 'start', store.createRecord(Vosae.EventDateTime, {})
    vosaeEvent.set 'start.date', (new Date(2013, 7, 9))

    # Test
    expect(vosaeEvent.get('allDay')).toBeFalsy()

    # Setup
    vosaeEvent.set 'end', store.createRecord(Vosae.EventDateTime, {})
    vosaeEvent.set 'end.date', (new Date(2013, 7, 9))

    # Test
    expect(vosaeEvent.get('allDay')).toBeTruthy()

    # Setup
    vosaeEvent.set 'allDay', true

    # Test
    expect(vosaeEvent.get('start.date')).toEqual (new Date(2013, 7, 9)) 
    expect(vosaeEvent.get('start.datetime')).toEqual null
    expect(vosaeEvent.get('end.date')).toEqual (new Date(2013, 7, 9)) 
    expect(vosaeEvent.get('end.datetime')).toEqual null

    # Setup 
    vosaeEvent.set 'start.date', null
    vosaeEvent.set 'start.datetime', (new Date(2013, 7, 9))
    vosaeEvent.set 'end.date', null
    vosaeEvent.set 'end.datetime', (new Date(2013, 7, 9))
    vosaeEvent.set 'allDay', true

    # Test
    expect(vosaeEvent.get('start.date')).toEqual (new Date(2013, 7, 9))
    expect(vosaeEvent.get('start.datetime')).toEqual null
    expect(vosaeEvent.get('end.date')).toEqual (new Date(2013, 7, 9))
    expect(vosaeEvent.get('end.datetime')).toEqual null

    # Setup
    vosaeEvent.set 'start.date', (new Date(2013, 7, 9))
    vosaeEvent.set 'start.datetime', null
    vosaeEvent.set 'end.date', (new Date(2013, 7, 9))
    vosaeEvent.set 'end.datetime', null
    vosaeEvent.set 'allDay', false

    # Test
    expect(vosaeEvent.get('start.date')).toEqual null
    expect(vosaeEvent.get('start.datetime')).toEqual (new Date(2013, 7, 9))
    expect(vosaeEvent.get('end.date')).toEqual null
    expect(vosaeEvent.get('end.datetime')).toEqual (new Date(2013, 7, 9))

    # # Setup 
    vosaeEvent.set 'start.date', (new Date(2013, 7, 9))
    vosaeEvent.set 'start.datetime', null
    vosaeEvent.set 'end.date', (new Date(2013, 7, 9))
    vosaeEvent.set 'end.datetime', null
    vosaeEvent.set 'allDay', false

    # # Test
    expect(vosaeEvent.get('start.date')).toEqual null
    expect(vosaeEvent.get('start.datetime')).toEqual (new Date(2013, 7, 9))
    expect(vosaeEvent.get('end.date')).toEqual null
    expect(vosaeEvent.get('end.datetime')).toEqual (new Date(2013, 7, 9))

  it 'displayDate should return and format start and end dates', ->
    # Setup
    store.adapterForType(Vosae.VosaeEvent).load store, Vosae.VosaeEvent, {id: 1}
    vosaeEvent = store.find Vosae.VosaeEvent, 1

    # Test
    expect(vosaeEvent.get('displayDate')).toBeFalsy()

    # Setup
    vosaeEvent.set 'start', store.createRecord(Vosae.EventDateTime, {})
    vosaeEvent.set 'start.date', (new Date(2013, 7, 9))
    vosaeEvent.set 'end', store.createRecord(Vosae.EventDateTime, {})
    vosaeEvent.set 'end.date', (new Date(2013, 7, 10))

    # Test
    expect(vosaeEvent.get('displayDate')).toEqual 'August Friday 9 - Saturday 10, 2013'

    # # Setup
    # vosaeEvent.set 'start.date', null
    # vosaeEvent.set 'start.datetime', (new Date(2013, 7, 9, 5, 10))
    # vosaeEvent.set 'end.date', null
    # vosaeEvent.set 'end.datetime', (new Date(2013, 7, 10, 5, 10))

    # # Test
    # expect(vosaeEvent.get('displayDate')).toEqual '???'

  it 'textColor property should return an hex color according to color', ->
    # Setup
    store.adapterForType(Vosae.VosaeEvent).load store, Vosae.VosaeEvent, {id: 1}
    vosaeEvent = store.find Vosae.VosaeEvent, 1

    # Test
    expect(vosaeEvent.get('textColor')).toEqual "#333"

    # Setup
    vosaeEvent.set 'color', '#000'

    # Test
    expect(vosaeEvent.get('textColor')).toEqual "#FEFEFE"

    # Setup
    vosaeEvent.set 'color', '#FFF'

    # Test
    expect(vosaeEvent.get('textColor')).toEqual "#333"

  it 'getFullCalendarEvent() method should return a dict with event properties', ->
    # Setup
    store.adapterForType(Vosae.VosaeEvent).load store, Vosae.VosaeEvent,
      id: 1
      summary: 'My title'
    vosaeEvent = store.find Vosae.VosaeEvent, 1
    vosaeEvent.set 'start', store.createRecord(Vosae.EventDateTime)
    vosaeEvent.set 'start.date', (new Date(2013, 7, 9))
    vosaeEvent.set 'end', store.createRecord(Vosae.EventDateTime)
    vosaeEvent.set 'end.date', (new Date(2013, 7, 10))

    # Test
    expect(vosaeEvent.getFullCalendarEvent()).toEqual {
      id: "1"
      title: 'My title'
      start: vosaeEvent.get('start.date')
      end: vosaeEvent.get('end.date')
      allDay: true
    }

    # Setup
    vosaeEvent.set 'color', '#FFF'

    # Test
    expect(vosaeEvent.getFullCalendarEvent()).toEqual {
      id: "1"
      title: 'My title'
      start: vosaeEvent.get('start.date')
      end: vosaeEvent.get('end.date')
      allDay: true
      color: "#FFF"
      textColor: "#333"
    }
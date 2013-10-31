store = null

describe 'Vosae.EventDateTime', ->
  beforeEach ->
    comp = getAdapterForTest(Vosae.EventDateTime)
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

  it 'allDay property getter/setter', ->
    # Setup
    store.adapterForType(Vosae.EventDateTime).load store, Vosae.EventDateTime, {id: 1}
    eventDateTime = store.find Vosae.EventDateTime, 1

    # Test
    expect(eventDateTime.get('allDay')).toBeFalsy()

    # Setup
    eventDateTime.set 'date', (new Date(2013, 7, 9))

    # Test
    expect(eventDateTime.get('allDay')).toBeTruthy()

    # Setup 
    date = eventDateTime.get('date')
    eventDateTime.set('allDay', false)

    # Test
    expect(eventDateTime.get('date')).toEqual null
    expect(eventDateTime.get('datetime')).toEqual date

    # Setup 
    datetime = eventDateTime.get('datetime')
    eventDateTime.set('allDay', true)

    # Test
    expect(eventDateTime.get('datetime')).toEqual null
    expect(eventDateTime.get('date')).toEqual moment(datetime).startOf('day').toDate()

  it 'dateOrDatetime property getter/setter', ->
    # Setup
    store.adapterForType(Vosae.EventDateTime).load store, Vosae.EventDateTime, {id: 1}
    eventDateTime = store.find Vosae.EventDateTime, 1

    # Test
    expect(eventDateTime.get('dateOrDatetime')).toEqual undefined

    # Setup
    eventDateTime.set 'date', (new Date(2013, 7, 9))

    # Test
    expect(eventDateTime.get('dateOrDatetime')).toEqual eventDateTime.get('date')

    # Setup
    eventDateTime.set 'date', null
    eventDateTime.set 'datetime', (new Date(2013, 7, 9))
    
    # Test
    expect(eventDateTime.get('dateOrDatetime')).toEqual eventDateTime.get('datetime')

    # Setup
    date = (new Date(2013, 7, 9))
    eventDateTime.set 'dateOrDatetime', date

    # Test
    expect(eventDateTime.get('date')).toEqual null
    expect(eventDateTime.get('datetime')).toEqual date

    # Setup
    eventDateTime.set 'datetime', null
    eventDateTime.set 'date', (new Date(2013, 7, 9))
    date = (new Date(2013, 7, 10))
    expectedValue = moment(date).startOf('day').toDate()
    eventDateTime.set 'dateOrDatetime', date

    # Test
    expect(eventDateTime.get('date')).toEqual expectedValue
    expect(eventDateTime.get('datetime')).toEqual null

  it 'onlyDate property getter/setter', ->
    # Setup
    store.adapterForType(Vosae.EventDateTime).load store, Vosae.EventDateTime, {id: 1}
    eventDateTime = store.find Vosae.EventDateTime, 1

    # Test
    expect((-> eventDateTime.get('onlyDate'))).toThrow(new Error("The onlyDate property must only be used to set the date"))

    # Setup
    dateTime = (new Date(2013, 7, 9, 1, 1, 1))
    eventDateTime.set 'dateOrDatetime', dateTime
    eventDateTime.set 'onlyDate', (new Date(2013, 8, 10))
    expectedDateTime = (new Date(2013, 8, 10, 1, 1, 1))

    # Test
    expect(eventDateTime.get('dateOrDatetime')).toEqual expectedDateTime

  it 'onlyTime property getter/setter', ->
    # Setup
    store.adapterForType(Vosae.EventDateTime).load store, Vosae.EventDateTime, {id: 1}
    eventDateTime = store.find Vosae.EventDateTime, 1

    # Test
    expect((-> eventDateTime.get('onlyTime'))).toThrow(new Error("The onlyTime property must only be used to set the time"))

    # Setup
    date = (new Date(2013, 7, 9))
    eventDateTime.set 'dateOrDatetime', date
    eventDateTime.set 'onlyTime', (new Date(2013, 8, 10, 5, 5))
    expectedDateTime = (new Date(2013, 7, 9, 5, 5))

    # Test
    expect(eventDateTime.get('dateOrDatetime')).toEqual expectedDateTime
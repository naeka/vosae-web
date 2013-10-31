store = null

describe 'Vosae.VosaeCalendar', ->
  hashVosaeCalendar = 
    summary: null
    description: null
    location: null
    timezone: null
    acl: null

  beforeEach ->
    comp = getAdapterForTest(Vosae.VosaeCalendar)
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

  it 'finding all vosaeCalendar makes a GET to /vosae_calendar/', ->
    # Setup
    vosaeCalendars = store.find Vosae.VosaeCalendar
    
    # Test
    enabledFlags vosaeCalendars, ['isLoaded', 'isValid'], recordArrayFlags
    expectAjaxURL "/vosae_calendar/"
    expectAjaxType "GET"

    # Setup
    ajaxHash.success(
      meta: {}
      objects: [$.extend({}, hashVosaeCalendar, {id: 1, summary: "My vosaeCalendar"})]
    )
    vosaeCalendar = vosaeCalendars.objectAt(0)

    # Test
    statesEqual vosaeCalendars, 'loaded.saved'
    stateEquals vosaeCalendar, 'loaded.saved'
    enabledFlagsForArray vosaeCalendars, ['isLoaded', 'isValid']
    enabledFlags vosaeCalendar, ['isLoaded', 'isValid']
    expect(vosaeCalendar).toEqual store.find(Vosae.VosaeCalendar, 1)

  it 'finding a vosaeCalendar by ID makes a GET to /vosae_calendar/:id/', ->
    # Setup
    vosaeCalendar = store.find Vosae.VosaeCalendar, 1

    # Test
    stateEquals vosaeCalendar, 'loading'
    enabledFlags vosaeCalendar, ['isLoading', 'isValid']
    expectAjaxType "GET"
    expectAjaxURL "/vosae_calendar/1/"

    # Setup
    ajaxHash.success($.extend {}, hashVosaeCalendar,
      id: 1
      summary: "My vosaeCalendar"
    )

    # Test
    stateEquals vosaeCalendar, 'loaded.saved'
    enabledFlags vosaeCalendar, ['isLoaded', 'isValid']
    expect(vosaeCalendar).toEqual store.find(Vosae.VosaeCalendar, 1)

  it 'finding vosaeCalendars by query makes a GET to /vosae_calendar/:query/', ->
    # Setup
    vosaeCalendars = store.find Vosae.VosaeCalendar, {page: 1}

    # Test
    expect(vosaeCalendars.get('length')).toEqual 0
    enabledFlags vosaeCalendars, ['isLoading'], recordArrayFlags
    expectAjaxURL "/vosae_calendar/"
    expectAjaxType "GET"
    expectAjaxData({page: 1 })

    # Setup
    ajaxHash.success(
      meta: {}
      objects: [
        $.extend {}, hashVosaeCalendar, {id: 1, summary: "My vosaeCalendar 1"}
        $.extend {}, hashVosaeCalendar, {id: 2, summary: "My vosaeCalendar 2"}
      ]
    )
    vosaeCalendar1 = vosaeCalendars.objectAt 0
    vosaeCalendar2 = vosaeCalendars.objectAt 1

    # Test
    statesEqual [vosaeCalendar1, vosaeCalendar2], 'loaded.saved'
    enabledFlags vosaeCalendars, ['isLoaded'], recordArrayFlags
    enabledFlagsForArray [vosaeCalendar1, vosaeCalendar2], ['isLoaded'], recordArrayFlags
    expect(vosaeCalendars.get('length')).toEqual 2
    expect(vosaeCalendar1.get('summary')).toEqual "My vosaeCalendar 1"
    expect(vosaeCalendar2.get('summary')).toEqual "My vosaeCalendar 2"
    expect(vosaeCalendar1.get('id')).toEqual "1"
    expect(vosaeCalendar2.get('id')).toEqual "2"

  it 'creating a vosaeCalendar makes a POST to /vosae_calendar/', ->
    # Setup
    vosaeCalendar = store.createRecord Vosae.VosaeCalendar, {summary: "My vosaeCalendar"}

    # Test
    stateEquals vosaeCalendar, 'loaded.created.uncommitted'
    enabledFlags vosaeCalendar, ['isLoaded', 'isDirty', 'isNew', 'isValid']

    # Setup
    vosaeCalendar.get('transaction').commit()

    # Test
    stateEquals vosaeCalendar, 'loaded.created.inFlight'
    enabledFlags vosaeCalendar, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']
    expectAjaxURL "/vosae_calendar/"
    expectAjaxType "POST"
    expectAjaxData($.extend {}, hashVosaeCalendar, {summary: "My vosaeCalendar"})

    # Setup
    ajaxHash.success($.extend {}, hashVosaeCalendar,
      id: 1
      summary: "My vosaeCalendar"
      resource_uri: "/api/v1/vosae_calendar/1/"
    )

    # Test
    stateEquals vosaeCalendar, 'loaded.saved'
    enabledFlags vosaeCalendar, ['isLoaded', 'isValid']
    expect(vosaeCalendar).toEqual store.find(Vosae.VosaeCalendar, 1)

  it 'updating a vosaeCalendar makes a PUT to /vosae_calendar/:id/', ->
    # Setup
    store.load Vosae.VosaeCalendar,
      id: 1
      summary: "My vosaeCalendar"
    vosaeCalendar = store.find Vosae.VosaeCalendar, 1

    # Test
    stateEquals vosaeCalendar, 'loaded.saved' 
    enabledFlags vosaeCalendar, ['isLoaded', 'isValid']

    # Setup
    vosaeCalendar.setProperties {summary: "My vosaeCalendar edited"}

    # Test
    stateEquals vosaeCalendar, 'loaded.updated.uncommitted'
    enabledFlags vosaeCalendar, ['isLoaded', 'isDirty', 'isValid']

    # Setup
    vosaeCalendar.get('transaction').commit()

    # Test
    stateEquals vosaeCalendar, 'loaded.updated.inFlight'
    enabledFlags vosaeCalendar, ['isLoaded', 'isDirty', 'isSaving', 'isValid']
    expectAjaxURL "/vosae_calendar/1/"
    expectAjaxType "PUT"
    expectAjaxData($.extend {}, hashVosaeCalendar,
      summary: "My vosaeCalendar edited"
    )

    # Setup
    ajaxHash.success($.extend {}, hashVosaeCalendar,
      id: 1
      summary: "My vosaeCalendar edited"
    )

    # Test
    stateEquals vosaeCalendar, 'loaded.saved'
    enabledFlags vosaeCalendar, ['isLoaded', 'isValid']
    expect(vosaeCalendar).toEqual store.find(Vosae.VosaeCalendar, 1)
    expect(vosaeCalendar.get('summary')).toEqual 'My vosaeCalendar edited'

  it 'deleting a vosaeCalendar makes a DELETE to /vosae_calendar/:id/', ->
    # Setup
    store.load Vosae.VosaeCalendar, {id: 1}
    vosaeCalendar = store.find Vosae.VosaeCalendar, 1

    # Test
    stateEquals vosaeCalendar, 'loaded.saved' 
    enabledFlags vosaeCalendar, ['isLoaded', 'isValid']

    # Setup
    vosaeCalendar.deleteRecord()

    # Test
    stateEquals vosaeCalendar, 'deleted.uncommitted'
    enabledFlags vosaeCalendar, ['isLoaded', 'isDirty', 'isDeleted', 'isValid']

    # Setup
    vosaeCalendar.get('transaction').commit()

    # Test
    stateEquals vosaeCalendar, 'deleted.inFlight'
    enabledFlags vosaeCalendar, ['isLoaded', 'isDirty', 'isSaving', 'isDeleted', 'isValid']
    expectAjaxURL "/vosae_calendar/1/"
    expectAjaxType "DELETE"

    # Setup
    ajaxHash.success()

    # Test
    stateEquals vosaeCalendar, 'deleted.saved'
    enabledFlags vosaeCalendar, ['isLoaded', 'isDeleted', 'isValid']

  it 'acl embedded belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.VosaeCalendar).load store, Vosae.VosaeCalendar, {id: 1, acl: {rules: [{role: "OWNER"}]}}
    vosaeCalendar = store.find Vosae.VosaeCalendar, 1

    # Test
    expect(vosaeCalendar.get('acl.rules.firstObject.role')).toEqual "OWNER"
# store = null

# describe 'Vosae.CalendarList', ->
#   hashCalendarList = 
#     summary: null
#     description: null
#     location: null
#     timezone: null
#     summary_override: null
#     color: null
#     selected: true
#     is_own: true
#     reminders: []

#   beforeEach ->
#     comp = getAdapterForTest(Vosae.CalendarList)
#     ajaxUrl = comp[0]
#     ajaxType = comp[1]
#     ajaxHash = comp[2]
#     store = comp[3]

#   afterEach ->
#     comp = undefined
#     ajaxUrl = undefined
#     ajaxType = undefined
#     ajaxHash = undefined
#     store.destroy()

#   it 'finding all calendarList makes a GET to /calendar_list/', ->
#     # Setup
#     calendarLists = store.find Vosae.CalendarList
    
#     # Test
#     enabledFlags calendarLists, ['isLoaded', 'isValid'], recordArrayFlags
#     expectAjaxURL "/calendar_list/"
#     expectAjaxType "GET"

#     # Setup
#     ajaxHash.success(
#       meta: {}
#       objects: [$.extend({}, hashCalendarList, {id: 1, summary: "My calendarList"})]
#     )
#     calendarList = calendarLists.objectAt(0)

#     # Test
#     statesEqual calendarLists, 'loaded.saved'
#     stateEquals calendarList, 'loaded.saved'
#     enabledFlagsForArray calendarLists, ['isLoaded', 'isValid']
#     enabledFlags calendarList, ['isLoaded', 'isValid']
#     expect(calendarList).toEqual store.find(Vosae.CalendarList, 1)

#   it 'finding a calendarList by ID makes a GET to /calendar_list/:id/', ->
#     # Setup
#     calendarList = store.find Vosae.CalendarList, 1

#     # Test
#     stateEquals calendarList, 'loading'
#     enabledFlags calendarList, ['isLoading', 'isValid']
#     expectAjaxType "GET"
#     expectAjaxURL "/calendar_list/1/"

#     # Setup
#     ajaxHash.success($.extend {}, hashCalendarList,
#       id: 1
#       summary: "My calendarList"
#     )

#     # Test
#     stateEquals calendarList, 'loaded.saved'
#     enabledFlags calendarList, ['isLoaded', 'isValid']
#     expect(calendarList).toEqual store.find(Vosae.CalendarList, 1)

#   it 'finding calendarLists by query makes a GET to /calendar_list/:query/', ->
#     # Setup
#     calendarLists = store.find Vosae.CalendarList, {page: 1}

#     # Test
#     expect(calendarLists.get('length')).toEqual 0
#     enabledFlags calendarLists, ['isLoading'], recordArrayFlags
#     expectAjaxURL "/calendar_list/"
#     expectAjaxType "GET"
#     expectAjaxData({page: 1 })

#     # Setup
#     ajaxHash.success(
#       meta: {}
#       objects: [
#         $.extend {}, hashCalendarList, {id: 1, summary: "My calendarList 1"}
#         $.extend {}, hashCalendarList, {id: 2, summary: "My calendarList 2"}
#       ]
#     )
#     calendarList1 = calendarLists.objectAt 0
#     calendarList2 = calendarLists.objectAt 1

#     # Test
#     statesEqual [calendarList1, calendarList2], 'loaded.saved'
#     enabledFlags calendarLists, ['isLoaded'], recordArrayFlags
#     enabledFlagsForArray [calendarList1, calendarList2], ['isLoaded'], recordArrayFlags
#     expect(calendarLists.get('length')).toEqual 2
#     expect(calendarList1.get('summary')).toEqual "My calendarList 1"
#     expect(calendarList2.get('summary')).toEqual "My calendarList 2"
#     expect(calendarList1.get('id')).toEqual "1"
#     expect(calendarList2.get('id')).toEqual "2"

#   it 'creating a calendarList makes a POST to /calendar_list/', ->
#     # Setup
#     calendarList = store.createRecord Vosae.CalendarList, {summary: "My calendarList"}

#     # Test
#     stateEquals calendarList, 'loaded.created.uncommitted'
#     enabledFlags calendarList, ['isLoaded', 'isDirty', 'isNew', 'isValid']

#     # Setup
#     calendarList.get('transaction').commit()

#     # Test
#     stateEquals calendarList, 'loaded.created.inFlight'
#     enabledFlags calendarList, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']
#     expectAjaxURL "/calendar_list/"
#     expectAjaxType "POST"
#     expectAjaxData($.extend {}, hashCalendarList, {summary: "My calendarList"})

#     # Setup
#     ajaxHash.success($.extend {}, hashCalendarList,
#       id: 1
#       summary: "My calendarList"
#       resource_uri: "/api/v1/calendar_list/1/"
#     )

#     # Test
#     stateEquals calendarList, 'loaded.saved'
#     enabledFlags calendarList, ['isLoaded', 'isValid']
#     expect(calendarList).toEqual store.find(Vosae.CalendarList, 1)

#   it 'updating a calendarList makes a PUT to /calendar_list/:id/', ->
#     # Setup
#     store.load Vosae.CalendarList,
#       id: 1
#       summary: "My calendarList"
#     calendarList = store.find Vosae.CalendarList, 1

#     # Test
#     stateEquals calendarList, 'loaded.saved' 
#     enabledFlags calendarList, ['isLoaded', 'isValid']

#     # Setup
#     calendarList.setProperties {summary: "My calendarList edited", isOwn: true, selected: true}

#     # Test
#     stateEquals calendarList, 'loaded.updated.uncommitted'
#     enabledFlags calendarList, ['isLoaded', 'isDirty', 'isValid']

#     # Setup
#     calendarList.get('transaction').commit()

#     # Test
#     stateEquals calendarList, 'loaded.updated.inFlight'
#     enabledFlags calendarList, ['isLoaded', 'isDirty', 'isSaving', 'isValid']
#     expectAjaxURL "/calendar_list/1/"
#     expectAjaxType "PUT"
#     expectAjaxData($.extend {}, hashCalendarList,
#       summary: "My calendarList edited"
#     )

#     # Setup
#     ajaxHash.success($.extend {}, hashCalendarList,
#       id: 1
#       summary: "My calendarList edited"
#     )

#     # Test
#     stateEquals calendarList, 'loaded.saved'
#     enabledFlags calendarList, ['isLoaded', 'isValid']
#     expect(calendarList).toEqual store.find(Vosae.CalendarList, 1)
#     expect(calendarList.get('summary')).toEqual 'My calendarList edited'

#   it 'deleting a calendarList makes a DELETE to /calendar_list/:id/', ->
#     # Setup
#     store.load Vosae.CalendarList, {id: 1}
#     calendarList = store.find Vosae.CalendarList, 1

#     # Test
#     stateEquals calendarList, 'loaded.saved' 
#     enabledFlags calendarList, ['isLoaded', 'isValid']

#     # Setup
#     calendarList.deleteRecord()

#     # Test
#     stateEquals calendarList, 'deleted.uncommitted'
#     enabledFlags calendarList, ['isLoaded', 'isDirty', 'isDeleted', 'isValid']

#     # Setup
#     calendarList.get('transaction').commit()

#     # Test
#     stateEquals calendarList, 'deleted.inFlight'
#     enabledFlags calendarList, ['isLoaded', 'isDirty', 'isSaving', 'isDeleted', 'isValid']
#     expectAjaxURL "/calendar_list/1/"
#     expectAjaxType "DELETE"

#     # Setup
#     ajaxHash.success()

#     # Test
#     stateEquals calendarList, 'deleted.saved'
#     enabledFlags calendarList, ['isLoaded', 'isDeleted', 'isValid']

#   it 'selected property should be equal to true by default', ->
#     # Setup
#     calendarList = store.createRecord Vosae.CalendarList, {}

#     # Test
#     expect(calendarList.get('selected')).toEqual true

#   it 'isOwn property should be equal to true by default', ->
#     # Setup
#     calendarList = store.createRecord Vosae.CalendarList, {}

#     # Test
#     expect(calendarList.get('isOwn')).toEqual true

#   it 'calendar belongsTo relationship', ->
#     # Setup
#     store.adapterForType(Vosae.VosaeCalendar).load store, Vosae.VosaeCalendar, {id: 1}
#     store.adapterForType(Vosae.CalendarList).load store, Vosae.CalendarList, {id: 1, calendar: "/api/v1/vosae_calendar/1/"}
#     vosaeCalendar = store.find Vosae.VosaeCalendar, 1
#     calendarList = store.find Vosae.CalendarList, 1

#     # Test
#     expect(calendarList.get('calendar')).toEqual vosaeCalendar

#   it 'displayName computed property return summaryOverride or summary', ->
#     # Setup
#     store.adapterForType(Vosae.CalendarList).load store, Vosae.CalendarList, {id: 1, calendar: "/api/v1/vosae_calendar/1/"}
#     calendarList = store.find Vosae.CalendarList, 1

#     # Test
#     expect(calendarList.get('displayName')).toBeFalsy()

#     # Setup
#     calendarList.set 'summary', 'My summary'

#     # Test
#     expect(calendarList.get('displayName')).toEqual 'My summary'

#     # Setup
#     calendarList.set 'summaryOverride', 'My summary override'

#     # Test
#     expect(calendarList.get('displayName')).toEqual 'My summary override'

#   it 'displayColor computed property should return the color fomarted', ->
#     # Setup
#     store.adapterForType(Vosae.CalendarList).load store, Vosae.CalendarList, {id: 1, calendar: "/api/v1/vosae_calendar/1/"}
#     calendarList = store.find Vosae.CalendarList, 1

#     # Test
#     expect(calendarList.get('displayColor')).toEqual ''
#     Vosae.Config.calendarListColors.forEach (color) ->
#       calendarList.set 'color', color.get('value')
#       expect(calendarList.get('displayColor')).toEqual color.get('displayName')


#   it 'displayTimezone computed property should return the timezone fomarted', ->
#     # Setup
#     store.adapterForType(Vosae.CalendarList).load store, Vosae.CalendarList, {id: 1, calendar: "/api/v1/vosae_calendar/1/"}
#     calendarList = store.find Vosae.CalendarList, 1

#     # Test
#     expect(calendarList.get('displayTimezone')).toEqual ''
#     Vosae.Timezones.forEach (timezone) ->
#       calendarList.set 'timezone', timezone.get('value')
#       expect(calendarList.get('displayTimezone')).toEqual timezone.get('displayName')

#   it 'textColor property should return an hex color according to color', ->
#     # Setup
#     store.adapterForType(Vosae.CalendarList).load store, Vosae.CalendarList, {id: 1, calendar: "/api/v1/vosae_calendar/1/"}
#     calendarList = store.find Vosae.CalendarList, 1

#     # Test
#     expect(calendarList.get('textColor')).toEqual "#333"

#     # Setup
#     calendarList.set 'color', '#000'

#     # Test
#     expect(calendarList.get('textColor')).toEqual "#FEFEFE"

#     # Setup
#     calendarList.set 'color', '#FFF'

#     # Test
#     expect(calendarList.get('textColor')).toEqual "#333"
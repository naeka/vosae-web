# store = null

# describe 'Vosae.CalendarAcl', ->
#   hashCalendarAcl = 
#     rules: []

#   beforeEach ->
#     comp = getAdapterForTest(Vosae.CalendarAcl)
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

#   it 'vosaeUser hasMany relationship', ->
#     # Setup
#     store.adapterForType(Vosae.User).load store, Vosae.User, {id: 1}
#     store.adapterForType(Vosae.CalendarAcl).load store, Vosae.CalendarAcl, 
#       id: 1
#       rules:[
#         {principal: "/api/v1/user/1/", role: "NONE"}
#       ]
#     calendarAcl = store.find Vosae.CalendarAcl, 1
#     calendarAclRule =  calendarAcl.get('rules').objectAt 0

#     # Test
#     expect(calendarAcl.get('rules.firstObject')).toEqual calendarAclRule
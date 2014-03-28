# store = null

# describe 'Vosae.Attendee', ->
#   hashAttendee = 
#     email: null
#     display_name: null
#     organizer: null
#     photo_uri: null
#     optional: null
#     response_status: null
#     comment: null

#   beforeEach ->
#     comp = getAdapterForTest(Vosae.Attendee)
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

#   it 'finding a attendee by ID makes a GET to /attendee/:id/', ->
#     # Setup
#     attendee = store.find Vosae.Attendee, 1
#     ajaxHash.success($.extend, {}, hashAttendee, {id: 1})

#     # Test
#     expectAjaxType "GET"
#     expectAjaxURL "/attendee/1/"
#     expect(attendee).toEqual store.find(Vosae.Attendee, 1)

#   it 'vosaeUser belongsTo relationship', ->
#     # Setup
#     store.adapterForType(Vosae.User).load store, Vosae.User, {id: 1}    
#     store.adapterForType(Vosae.Attendee).load store, Vosae.Attendee, {id: 1, vosae_user: "/api/v1/user/1/"}
#     user = store.find Vosae.User, 1
#     attendee = store.find Vosae.Attendee, 1

#     # Test
#     expect(attendee.get('vosaeUser')).toEqual user
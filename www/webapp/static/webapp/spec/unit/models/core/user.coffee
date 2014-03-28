# store = null

# describe 'Vosae.User', ->
#   hashUser =
#     email: null
#     full_name: null
#     groups: []
#     permissions: []
#     photo_uri: null
#     settings: null
#     specific_permissions: {}
#     status: null

#   beforeEach ->
#     comp = getAdapterForTest(Vosae.User)
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

#   it 'finding all user makes a GET to /user/', ->
#     # Setup
#     users = store.find Vosae.User

#     # Test
#     enabledFlags users, ['isLoaded', 'isValid'], recordArrayFlags
#     expectAjaxURL "/user/"
#     expectAjaxType "GET"

#     # Setup
#     ajaxHash.success(
#       meta: {}
#       objects: [$.extend({}, hashUser, {id: 1, full_name: "Tom Dale", email: "tom.dale@vosae.com"})]
#     )
#     user = users.objectAt(0)

#     # Test
#     statesEqual users, 'loaded.saved'
#     stateEquals user, 'loaded.saved'
#     enabledFlagsForArray users, ['isLoaded', 'isValid']
#     enabledFlags user, ['isLoaded', 'isValid']
#     expect(user).toEqual store.find(Vosae.User, 1)

#   it 'finding a user by ID makes a GET to /user/:id/', ->
#     # Setup
#     user = store.find Vosae.User, 1

#     # Test
#     stateEquals user, 'loading'
#     enabledFlags user, ['isLoading', 'isValid']
#     expectAjaxType "GET"
#     expectAjaxURL "/user/1/"

#     # Setup
#     ajaxHash.success($.extend {}, hashUser,
#       id: 1
#       full_name: "Tom Dale"
#       email: "tom.dale@vosae.com"
#       resource_uri: "/api/v1/user/1/"
#     )

#     # Test
#     stateEquals user, 'loaded.saved'
#     enabledFlags user, ['isLoaded', 'isValid']
#     expect(user).toEqual store.find(Vosae.User, 1)

#   it 'finding users by query makes a GET to /user/:query/', ->
#     # Setup
#     users = store.find Vosae.User, {page: 1}

#     # Test
#     expect(users.get('length')).toEqual 0
#     enabledFlags users, ['isLoading'], recordArrayFlags
#     expectAjaxURL "/user/"
#     expectAjaxType "GET"
#     expectAjaxData({page: 1 })

#     # Setup
#     ajaxHash.success(
#       meta: {}
#       objects: [
#         $.extend({}, hashUser, {id: 1, full_name: "Tom Dale", email: "tom.dale@vosae.com"})
#         $.extend({}, hashUser, {id: 2, full_name: "Yehuda Katz", email: "yehuda.katz@vosae.com"})
#       ]
#     )
#     tom = users.objectAt 0
#     yehuda = users.objectAt 1

#     # Test
#     statesEqual [tom, yehuda], 'loaded.saved'
#     enabledFlags users, ['isLoaded'], recordArrayFlags
#     enabledFlagsForArray [tom, yehuda], ['isLoaded'], recordArrayFlags
#     expect(users.get('length')).toEqual 2
#     expect(tom.get('fullName')).toEqual "Tom Dale"
#     expect(yehuda.get('fullName')).toEqual "Yehuda Katz"
#     expect(tom.get('id')).toEqual "1"
#     expect(yehuda.get('id')).toEqual "2"

#   it 'creating a user makes a POST to /user/', ->
#     # Setup
#     user = store.createRecord Vosae.User, {fullName: "Tom Dale", email: "tom.dale@vosae.com"}

#     # Test
#     stateEquals user, 'loaded.created.uncommitted'
#     enabledFlags user, ['isLoaded', 'isDirty', 'isNew', 'isValid']

#     # Setup
#     user.get('transaction').commit()

#     # Test
#     stateEquals user, 'loaded.created.inFlight'
#     enabledFlags user, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']
#     expectAjaxURL "/user/"
#     expectAjaxType "POST"
#     expectAjaxData($.extend {}, hashUser, {full_name: "Tom Dale", email: "tom.dale@vosae.com"})

#     # Setup
#     ajaxHash.success($.extend {}, hashUser,
#       id: 1
#       full_name: "Tom Dale"
#       email: "tom.dale@vosae.com"
#       resource_uri: "/api/v1/user/1/"
#     )

#     # Test
#     stateEquals user, 'loaded.saved'
#     enabledFlags user, ['isLoaded', 'isValid']
#     expect(user).toEqual store.find(Vosae.User, 1)

#   it 'updating a user makes a PUT to /user/:id/', ->
#     # Setup
#     # store.load Vosae.Group, {id: 1, name: "Administrators"}
#     store.adapterForType(Vosae.User).load store, Vosae.User, {id: 1, fullName: "Tom Dale", email: "tom.dale@vosae.com"}
#     user = store.find Vosae.User, 1

#     # Test
#     stateEquals user, 'loaded.saved' 
#     enabledFlags user, ['isLoaded', 'isValid']

#     # Setup
#     user.setProperties {fullName: "Yehuda Katz", email: "yehuda.katz@vosae.com"}

#     # Test
#     stateEquals user, 'loaded.updated.uncommitted'
#     enabledFlags user, ['isLoaded', 'isDirty', 'isValid']

#     # Setup
#     user.get('transaction').commit()

#     # Test
#     stateEquals user, 'loaded.updated.inFlight'
#     enabledFlags user, ['isLoaded', 'isDirty', 'isSaving', 'isValid']
#     expectAjaxURL "/user/1/"
#     expectAjaxType "PUT"
#     expectAjaxData($.extend {}, hashUser,
#       full_name: "Yehuda Katz"
#       email: "yehuda.katz@vosae.com"
#     )

#     # Setup
#     ajaxHash.success($.extend {}, hashUser,
#       id: 1
#       full_name: "Yehuda Katz", 
#       email: "yehuda.katz@vosae.com"
#     )

#     # Test
#     stateEquals user, 'loaded.saved'
#     enabledFlags user, ['isLoaded', 'isValid']
#     expect(user).toEqual store.find(Vosae.User, 1)
#     expect(user.get('fullName')).toEqual 'Yehuda Katz'

#   it 'deleting a user makes a DELETE to /user/:id/', ->
#     # Setup
#     store.adapterForType(Vosae.User).load store, Vosae.User, {id: 1, fullName: "Tom Dale"}
#     user = store.find Vosae.User, 1

#     # Test
#     stateEquals user, 'loaded.saved' 
#     enabledFlags user, ['isLoaded', 'isValid']

#     # Setup
#     user.deleteRecord()

#     # Test
#     stateEquals user, 'deleted.uncommitted'
#     enabledFlags user, ['isLoaded', 'isDirty', 'isDeleted', 'isValid']

#     # Setup
#     user.get('transaction').commit()

#     # Test
#     stateEquals user, 'deleted.inFlight'
#     enabledFlags user, ['isLoaded', 'isDirty', 'isSaving', 'isDeleted', 'isValid']
#     expectAjaxURL "/user/1/"
#     expectAjaxType "DELETE"

#     # Setup
#     ajaxHash.success()

#     # Test
#     stateEquals user, 'deleted.saved'
#     enabledFlags user, ['isLoaded', 'isDeleted', 'isValid']

#   it 'groups hasMany relationship', ->
#     # Setup
#     store.adapterForType(Vosae.Group).load store, Vosae.Group, {id: 1, name: 'Administrators'}
#     group = store.find Vosae.Group, 1
#     store.adapterForType(Vosae.User).load store, Vosae.User, {id: 1, groups:['/api/v1/group/1/']}
#     user = store.find Vosae.User, 1

#     # Test
#     expect(user.get('groups').objectAt(0)).toEqual group

#   it 'specificPermissions hasMany relationship', ->
#     # Setup
#     store.adapterForType(Vosae.User).load store, Vosae.User, {id: 1, specific_permissions:{'can_edit_contact': true}}
#     user = store.find Vosae.User, 1

#     # Test
#     expect(user.get('specificPermissions').objectAt(0).get('name')).toEqual 'can_edit_contact'
#     expect(user.get('specificPermissions').objectAt(0).get('value')).toEqual true

#   it 'settings belongsTo relationship', ->
#     # Setup
#     store.adapterForType(Vosae.User).load store, Vosae.User, {id: 1, settings:{language_code: "fr"}}
#     user = store.find Vosae.User, 1

#     # Test
#     expect(user.get('settings.languageCode')).toEqual 'fr'

#   it 'permissions property should be empty when creating user', ->
#     # Setup
#     user = store.createRecord Vosae.User

#     # Test
#     expect(user.get('permissions')).toEqual []

#   it 'permissionsContains() method should return false if user hasnt perm', ->
#     # Setup
#     store.adapterForType(Vosae.User).load store, Vosae.User, {id: 1, permissions:['can_edit_contact']}
#     user = store.find Vosae.User, 1

#     # Test
#     expect(user.permissionsContains('can_edit_contact')).toEqual true
#     expect(user.permissionsContains('can_edit_organization')).toEqual false

#   it 'specificPermissionsContains() method should return false if user hasnt perm', ->
#     # Setup
#     store.adapterForType(Vosae.User).load store, Vosae.User, {id: 1, specific_permissions:{'can_edit_contact': true}}
#     user = store.find Vosae.User, 1
#     specificPerm = user.specificPermissionsContains('can_edit_contact')
#     specificPerm2 = user.specificPermissionsContains('can_edit_organization')

#     # Test
#     expect(specificPerm.get('name')).toEqual 'can_edit_contact'
#     expect(specificPerm.get('value')).toEqual true
#     expect(specificPerm2).toEqual false

#   it 'mergeGroupsPermissions() should merge groups permissions into user permissions', ->
#     # Setup
#     store.adapterForType(Vosae.Group).load store, Vosae.Group, {id: 1, permissions:['can_edit_contact', 'can_add_quotation']}
#     store.adapterForType(Vosae.Group).load store, Vosae.Group, {id: 2, permissions:['can_edit_organization', 'can_edit_contact']}
#     group1 = store.find Vosae.Group, 1
#     group2 = store.find Vosae.Group, 2
#     store.adapterForType(Vosae.User).load store, Vosae.User, {id: 1, groups:['/api/v1/group/1/', '/api/v1/group/2/']}
#     user = store.find Vosae.User, 1
#     user.mergeGroupsPermissions()

#     # Test
#     expect(user.get('permissions').get('length')).toEqual 3
#     expect(user.permissionsContains('can_edit_contact')).toEqual true
#     expect(user.permissionsContains('can_edit_organization')).toEqual true
#     expect(user.permissionsContains('can_add_quotation')).toEqual true

#   it 'getStatus computed property should return user\'s status', ->
#     # Setup
#     store.adapterForType(Vosae.User).load store, Vosae.User, {id: 1, status: 'ACTIVE'}
#     user = store.find Vosae.User, 1

#     # Test
#     expect(user.get('getStatus')).toEqual 'Active'

#     # Setup
#     user.set 'status', 'SOMETHINGWRONG'

#     # Test
#     expect(user.get('getStatus')).toEqual 'Unknown'

#   it 'getFullName computed property should return user\'s full name', ->
#     # Setup
#     store.adapterForType(Vosae.User).load store, Vosae.User, {id: 1, full_name: 'Tom Dale'}
#     user = store.find Vosae.User, 1

#     # Test
#     expect(user.get('getFullName')).toEqual 'Tom Dale'

#     # Setup
#     user.set 'fullName', ''

#     # Test
#     expect(user.get('getFullName')).toEqual 'To define'
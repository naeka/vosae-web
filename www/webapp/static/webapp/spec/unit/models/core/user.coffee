env = undefined
store = undefined

module "DS.Model / Vosae.User",
  setup: ->
    env = setupStore()

    # Register transforms
    env.container.register 'transform:array', Vosae.ArrayTransform

    # Make the store available for all tests
    store = env.store

test 'relationship - group', ->
  # Setup
  store.push 'group', {id: 1, name: 'Admin'}
  store.push 'user', {id: 1, groups: [1]}

  # Test
  store.find('user', 1).then async (user) ->
    equal user.get('groups').objectAt(0) instanceof Vosae.Group, true, "the first object in the groups property should return group"
    equal user.get('groups').objectAt(0).get('name'), "Admin", "the first group in groups should have a name"

test 'relationship - specificPermissions', ->
  # Setup
  store.push 'specificPermission', {id: 1, name: "can_edit_contact", value: true}
  store.push 'user', {id: 1, specificPermissions:[1]}

  # Test
  store.find('user', 1).then async (user) ->
    equal user.get('specificPermissions').objectAt(0) instanceof Vosae.SpecificPermission, true, "the first object in the specificPermissions property should return specific permission"
    equal user.get('specificPermissions').objectAt(0).get('name'), "can_edit_contact", "the specific permission should have a name"
    equal user.get('specificPermissions').objectAt(0).get('value'), true, "the specific permission should have a value"

test 'relationship - settings', ->
  # Setup
  store.push 'userSettings', {id: 1, languageCode: 'fr'}
  store.push 'user', {id: 1, settings: 1}

  # Test
  store.find('user', 1).then async (user) ->
    equal user.get('settings') instanceof Vosae.UserSettings, true, "the settings property should return a user settings"
    equal user.get('settings.languageCode'), "fr", "the user settings should have a language code"

test 'method - permissionsContains', ->
  # Setup
  store.push 'user', {id: 1, permissions:['can_edit_contact']}

  # Test
  store.find('user', 1).then async (user) ->
    equal user.permissionsContains('can_edit_contact'), true, "permissionsContains should return true if user has the permission"
    equal user.permissionsContains('can_edit_organization'), false, "permissionsContains should return false if user hasnt the permission"

test 'method - specificPermissionsContains', ->
  # Setup
  store.push 'specificPermission', {id: 1, name: "can_edit_contact", value: true}
  store.push 'user', {id: 1, specificPermissions:[1]}

  # Test
  store.find('user', 1).then async (user) ->
    equal user.specificPermissionsContains('can_edit_contact'), true, "specificPermissionsContains should return true if user has the permission"
    equal user.specificPermissionsContains('can_edit_organization'), false, "specificPermissionsContains should return false if user hasnt the permission"

test 'method - mergeGroupsPermissions', ->
  # Setup
  store.push 'group', {id: 1, permissions:['can_edit_contact', 'can_add_quotation']}
  store.push 'group', {id: 2, permissions:['can_edit_organization', 'can_edit_contact']}
  store.push 'user', {id: 1,  groups: [1, 2]}

  # Test
  store.find('user', 1).then async (user) ->
    Em.RSVP.all([store.find('group', 1), store.find('group', 2)]).then async (groups) ->
      user.mergeGroupsPermissions()
      equal user.get('permissions').get('length'), 3, "user permissions array's length should be 3"
      equal user.permissionsContains('can_edit_contact'), true, "user should have the permission can_edit_contact"
      equal user.permissionsContains('can_edit_organization'), true, "user should have the permission can_edit_organization"
      equal user.permissionsContains('can_add_quotation'), true, "user should have the permission can_add_quotation"

test 'property - permissions', ->
  # Setup
  store.push 'user', {id: 1}

  # Test
  store.find('user', 1).then async (user) ->
    deepEqual user.get('permissions'), [], "the default value for the permissions property should be an empty array"

test 'computedProperty - getStatus', ->
  # Setup
  store.push 'user', {id: 1, status: 'ACTIVE'}

  # Test
  store.find('user', 1).then async (user) ->
    equal user.get('getStatus'), "Active", "the getStatus property should return the user's status"
    user.set 'status', 'SOMETHINGWRONG'
    equal user.get('getStatus'), 'Unknown', "the getStatus property should return 'Unknown' if the user's status doesn't exist"

test 'computedProperty - getFullName', ->
  # Setup
  store.push 'user', {id: 1, fullName: 'Thomas Durin'}

  # Test
  store.find('user', 1).then async (user) ->
    equal user.get('getFullName'), "Thomas Durin", "the getFullName property should return the user's full name"
    user.set 'fullName', ''
    equal user.get('getFullName'), "To define", "the getFullName property should return 'To define' if the user's full name doesn't exist"

test 'computedProperty - isDeleteable', ->
  # Setup
  store.push 'user', {id: 1, status: 'DELETED'}

  # Test
  store.find('user', 1).then async (user) ->
    equal user.get('isDeleteable'), false, "the isDeleteable property should false if the user already has the deleted status"
    user.set 'status', ''
    equal user.get('isDeleteable'), true, "the isDeleteable property should true if the user hasn't the deleted status"

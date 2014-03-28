env = undefined
store = undefined

module "DS.Model / Vosae.Group",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'relationship - createdBy', ->
  # Setup
  store.push 'user', {id: 1, fullName: 'Thomas Durin'}
  store.push 'group', {id: 1, createdBy: 1}

  # Test
  store.find('group', 1).then async (group) ->
    equal group.get('createdBy') instanceof Vosae.User, true, "the createdBy property should return a user"
    equal group.get('createdBy.fullName'), "Thomas Durin", "the user should have a name"

test 'method - loadPermissionsFromGroup', ->
  # Setup
  store.push 'group', {id: 1, permissions: ['can_edit_organization']}
  store.push 'group', {id: 2, permissions: []}

  # Test
  Em.RSVP.all([store.find('group', 1), store.find('group', 2)]).then async (groups) ->
    groups[1].loadPermissionsFromGroup groups[0]
    deepEqual groups[1].get('permissions'), ['can_edit_organization'], "permissions should have been loaded"
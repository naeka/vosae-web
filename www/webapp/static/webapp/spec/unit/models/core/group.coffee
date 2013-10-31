store = null

describe 'Vosae.Group', ->
  hashGroup =
    name: null
    permissions: []

  beforeEach ->
    comp = getAdapterForTest(Vosae.Group)
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

  it 'finding all group makes a GET to /group/', ->
    # Setup
    groups = store.find Vosae.Group

    # Test
    enabledFlags groups, ['isLoaded', 'isValid'], recordArrayFlags
    expectAjaxURL "/group/"
    expectAjaxType "GET"

    # Setup
    ajaxHash.success(
      meta: {}
      objects: [$.extend({}, hashGroup, {id: 1, name: "Administrators"})]
    )
    group = groups.objectAt(0)

    # Test
    statesEqual groups, 'loaded.saved'
    stateEquals group, 'loaded.saved'
    enabledFlagsForArray groups, ['isLoaded', 'isValid']
    enabledFlags group, ['isLoaded', 'isValid']
    expect(group).toEqual store.find(Vosae.Group, 1)

  it 'finding a group by ID makes a GET to /group/:id/', ->
    # Setup
    group = store.find Vosae.Group, 1

    # Test
    stateEquals group, 'loading'
    enabledFlags group, ['isLoading', 'isValid']
    expectAjaxType "GET"
    expectAjaxURL "/group/1/"

    # Setup
    ajaxHash.success($.extend {}, hashGroup,
      id: 1
      name: "Administrators"
      resource_uri: "/api/v1/group/1/"
    )

    # Test
    stateEquals group, 'loaded.saved'
    enabledFlags group, ['isLoaded', 'isValid']
    expect(group).toEqual store.find(Vosae.Group, 1)

  it 'finding groups by query makes a GET to /group/:query/', ->
    # Setup
    groups = store.find Vosae.Group, {page: 1}

    # Test
    expect(groups.get('length')).toEqual 0
    enabledFlags groups, ['isLoading'], recordArrayFlags
    expectAjaxURL "/group/"
    expectAjaxType "GET"
    expectAjaxData({page: 1 })

    # Setup
    ajaxHash.success(
      meta: {}
      objects: [
        $.extend({}, hashGroup, {id: 1, name: "Administrators"})
        $.extend({}, hashGroup, {id: 2, name: "Users",})
      ]
    )
    administrators = groups.objectAt 0
    users = groups.objectAt 1

    # Test
    statesEqual [administrators, users], 'loaded.saved'
    enabledFlags groups, ['isLoaded'], recordArrayFlags
    enabledFlagsForArray [administrators, users], ['isLoaded'], recordArrayFlags
    expect(groups.get('length')).toEqual 2
    expect(administrators.get('name')).toEqual "Administrators"
    expect(users.get('name')).toEqual "Users"
    expect(administrators.get('id')).toEqual "1"
    expect(users.get('id')).toEqual "2"

  it 'creating a group makes a POST to /group/', ->
    # Setup
    group = store.createRecord Vosae.Group, {name: "Administrators"}

    # Test
    stateEquals group, 'loaded.created.uncommitted'
    enabledFlags group, ['isLoaded', 'isDirty', 'isNew', 'isValid']

    # Setup
    group.get('transaction').commit()

    # Test
    stateEquals group, 'loaded.created.inFlight'
    enabledFlags group, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']
    expectAjaxURL "/group/"
    expectAjaxType "POST"
    expectAjaxData $.extend({}, hashGroup, {name: "Administrators"})

    # Setup
    ajaxHash.success($.extend {}, hashGroup,
      id: 1
      name: "Administrators"
      created_by: "/api/v1/user/1/"
      resource_uri: "/api/v1/group/1/"
    )

    # Test
    stateEquals group, 'loaded.saved'
    enabledFlags group, ['isLoaded', 'isValid']
    expect(group).toEqual store.find(Vosae.Group, 1)

  it 'updating a group makes a PUT to /group/:id/', ->
    # Setup
    store.adapterForType(Vosae.Group).load store, Vosae.Group, {id: 1, name: "Administrators"}
    group = store.find Vosae.Group, 1

    # Test
    stateEquals group, 'loaded.saved' 
    enabledFlags group, ['isLoaded', 'isValid']

    # Setup
    group.setProperties {name: "Secretaries"}

    # Test
    stateEquals group, 'loaded.updated.uncommitted'
    enabledFlags group, ['isLoaded', 'isDirty', 'isValid']

    # Setup
    group.get('transaction').commit()

    # Test
    stateEquals group, 'loaded.updated.inFlight'
    enabledFlags group, ['isLoaded', 'isDirty', 'isSaving', 'isValid']
    expectAjaxURL "/group/1/"
    expectAjaxType "PUT"
    expectAjaxData($.extend {}, hashGroup,
      name: "Secretaries"
    )

    # Setup
    ajaxHash.success($.extend {}, hashGroup,
      id: 1
      name: "Secretaries", 
    )

    # Test
    stateEquals group, 'loaded.saved'
    enabledFlags group, ['isLoaded', 'isValid']
    expect(group).toEqual store.find(Vosae.Group, 1)
    expect(group.get('name')).toEqual 'Secretaries'

  it 'deleting a group makes a DELETE to /group/:id/', ->
    # Setup
    store.adapterForType(Vosae.Group).load store, Vosae.Group, {id: 1, name: "Administrators"}
    group = store.find Vosae.Group, 1

    # Test
    stateEquals group, 'loaded.saved' 
    enabledFlags group, ['isLoaded', 'isValid']

    # Setup
    group.deleteRecord()

    # Test
    stateEquals group, 'deleted.uncommitted'
    enabledFlags group, ['isLoaded', 'isDirty', 'isDeleted', 'isValid']

    # Setup
    group.get('transaction').commit()

    # Test
    stateEquals group, 'deleted.inFlight'
    enabledFlags group, ['isLoaded', 'isDirty', 'isSaving', 'isDeleted', 'isValid']
    expectAjaxURL "/group/1/"
    expectAjaxType "DELETE"

    # Setup
    ajaxHash.success()

    # Test
    stateEquals group, 'deleted.saved'
    enabledFlags group, ['isLoaded', 'isDeleted', 'isValid']

  it 'createdBy belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.User).load store, Vosae.User, {id: 1}
    user = store.find Vosae.User, 1
    store.adapterForType(Vosae.Group).load store, Vosae.Group, {id: 1, created_by: '/api/v1/user/1/'}
    group = store.find Vosae.Group, 1

    # Test
    expect(group.get('createdBy')).toEqual user

  it 'loadPermissionsFromGroup() method should load and set permissions from another group', ->
    # Setup
    store.adapterForType(Vosae.Group).load store, Vosae.Group, {id: 1, permissions: ['can_edit_organization']}
    store.adapterForType(Vosae.Group).load store, Vosae.Group, {id: 2, permissions: []}
    group1 = store.find Vosae.Group, 1
    group2 = store.find Vosae.Group, 2
    group2.loadPermissionsFromGroup(group1)

    # Test
    expect(group2.get('permissions')).toEqual ['can_edit_organization']

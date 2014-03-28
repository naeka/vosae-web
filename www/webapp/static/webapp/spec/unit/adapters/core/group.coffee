env = undefined
store = undefined
adapter = undefined
passedUrl = undefined
passedVerb = undefined
passedHash = undefined

module "DS.RESTAdapter / Vosae.GroupAdapter",
  setup: ->
    env = setupStore()

    # Register transforms
    env.container.register 'transform:array', Vosae.ArrayTransform
    env.container.register 'transform:datetime', Vosae.DatetimeTransform

    # Make the store and the adapter available for all tests
    store = env.store
    adapter = store.adapterFor 'group'

    # Reset ajax vars
    passedUrl = null
    passedVerb = null
    passedHash = null

test 'find', ->
  # Setup
  ajaxResponse {id: 1, name: 'admin'}

  # Test
  store.find('group', 1).then async (group) ->
    equal passedUrl, "/group/1/", "finding a group by ID makes a GET to /group/:id/"
    equal passedVerb, "GET"

    equal group.get('id'), "1", "the group's ID is 1"
    equal group.get('name'), "admin", "the group's name is admin"

test 'findAll', ->
  # Setup
  ajaxResponse {objects: [{id: 1, name: 'admin'}]}

  # Test
  store.find('group').then async (groups) ->
    equal passedUrl, "/group/", "finding groups makes a GET to /group/"
    equal passedVerb, "GET"

    equal groups.get('length'), 1, "the groups array's length is 1 after a record is loaded into it"
    equal groups.objectAt(0).get('name'), 'admin', "the first group in the record array is admin"

test 'createRecord', ->
  # Setup
  ajaxResponse {id: 1, name: 'admin'}

  # Test
  store.createRecord('group').save().then async (group) ->
    equal passedUrl, "/group/", "creating a group makes a POST to /group/"
    equal passedVerb, "POST"

test 'updateRecord', ->
  # Setup
  store.push 'group', {id: 1, name: 'admin'}

  # Test
  store.find('group', 1).then(async (group) ->
    ajaxResponse()
    group.save()
  ).then async (group) ->
    equal passedUrl, "/group/1/", "updating a group makes a PUT to /group/1/"
    equal passedVerb, "PUT"

test 'deleteRecord', ->
  # Setup
  store.push 'group', {id: 1, name: 'admin'}

  # Test
  store.find('group', 1).then(async (group) ->
    ajaxResponse()
    group.destroyRecord()
  ).then async (group) ->
    equal passedUrl, "/group/1/", "deleting a group makes a DELETE to /group/1/"
    equal passedVerb, "DELETE"

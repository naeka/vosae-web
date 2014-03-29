env = undefined
store = undefined
adapter = undefined
passedUrl = undefined
passedVerb = undefined
passedHash = undefined

module "DS.RESTAdapter / Vosae.UserAdapter",
  setup: ->
    env = setupStore()

    # Register transforms
    env.container.register 'transform:array', Vosae.ArrayTransform

    # Register needed adapters & serializers
    env.container.register 'serializer:user', Vosae.UserSerializer

    # Make the store and the adapter available for all tests
    store = env.store
    adapter = store.adapterFor 'user'

    # Reset ajax vars
    passedUrl = null
    passedVerb = null
    passedHash = null

test 'find', ->
  # Setup
  ajaxResponse {id: 1, full_name: 'Thomas Durin'}

  # Test
  store.find('user', 1).then async (user) ->
    equal passedUrl, "/user/1/", "finding a user by ID makes a GET to /user/:id/"
    equal passedVerb, "GET"

    equal user.get('id'), "1", "the user's ID is 1"
    equal user.get('fullName'), "Thomas Durin", "the user's fullName is Thomas Durin"

test 'findAll', ->
  # Setup
  ajaxResponse {objects: [{id: 1, full_name: 'Thomas Durin'}]}

  # Test
  store.find('user').then async (users) ->
    equal passedUrl, "/user/", "finding users makes a GET to /user/"
    equal passedVerb, "GET"

    equal users.get('length'), 1, "the users array's length is 1 after a record is loaded into it"
    equal users.objectAt(0).get('fullName'), 'Thomas Durin', "the first user in the record array is Thomas Durin"

test 'createRecord', ->
  # Setup
  ajaxResponse {id: 1, full_name: 'Thomas Durin'}

  # Test
  store.createRecord('user').save().then async (user) ->
    equal passedUrl, "/user/", "creating a user makes a POST to /user/"
    equal passedVerb, "POST"

test 'updateRecord', ->
  # Setup
  store.push 'user', {id: 1, fullName: 'Thomas Durin'}

  # Test
  store.find('user', 1).then(async (user) ->
    ajaxResponse()
    user.save()
  ).then async (user) ->
    equal passedUrl, "/user/1/", "updating a user makes a PUT to /user/1/"
    equal passedVerb, "PUT"

test 'deleteRecord', ->
  # Setup
  store.push 'user', {id: 1, fullName: 'Thomas Durin'}

  # Test
  store.find('user', 1).then(async (user) ->
    ajaxResponse()
    user.destroyRecord()
  ).then async (user) ->
    equal passedUrl, "/user/1/", "deleting a user makes a DELETE to /user/1/"
    equal passedVerb, "DELETE"

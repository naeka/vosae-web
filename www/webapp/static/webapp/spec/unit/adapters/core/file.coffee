env = undefined
store = undefined
adapter = undefined
passedUrl = undefined
passedVerb = undefined
passedHash = undefined

module "DS.RESTAdapter / Vosae.FileAdapter",
  setup: ->
    env = setupStore
      file: Vosae.File
      user: Vosae.User
      group: Vosae.Group
      userSettings: Vosae.UserSettings
      specificPermission: Vosae.SpecificPermission

    # Register transforms
    env.container.register 'transform:date', Vosae.DateTransform
    env.container.register 'transform:datetime', Vosae.DatetimeTransform

    # Make the store and the adapter available for all tests
    store = env.store
    adapter = store.adapterFor 'file'

    # Reset ajax vars
    passedUrl = null
    passedVerb = null
    passedHash = null

test 'find', ->
  # Setup
  ajaxResponse {id: 1, name: 'myFile.png'}

  # Test
  store.find('file', 1).then async (file) ->
    equal passedUrl, "/file/1/", "finding a file by ID makes a GET to /file/:id/"
    equal passedVerb, "GET"

    equal file.get('id'), "1", "the file's ID is 1"
    equal file.get('name'), "myFile.png", "the file's name is myFile.png"

test 'findAll', ->
  # Setup
  ajaxResponse {objects: [{id: 1, name: 'myFile.png'}]}

  # Test
  store.find('file').then async (files) ->
    equal passedUrl, "/file/", "finding files makes a GET to /file/"
    equal passedVerb, "GET"

    equal files.get('length'), 1, "the files array's length is 1 after a record is loaded into it"
    equal files.objectAt(0).get('name'), 'myFile.png', "the first file in the record array is myFile.png"

test 'createRecord', ->
  # Setup
  ajaxResponse {id: 1, name: 'myFile.png'}

  # Test
  store.createRecord('file').save().then async (file) ->
    equal passedUrl, "/file/", "creating a file makes a POST to /file/"
    equal passedVerb, "POST"

test 'updateRecord', ->
  # Setup
  store.push 'file', {id: 1, name: 'myFile.png'}

  # Test
  store.find('file', 1).then(async (file) ->
    ajaxResponse()
    file.save()
  ).then async (file) ->
    equal passedUrl, "/file/1/", "updating a file makes a PUT to /file/1/"
    equal passedVerb, "PUT"

test 'deleteRecord', ->
  # Setup
  store.push 'file', {id: 1, name: 'myFile.png'}

  # Test
  store.find('file', 1).then(async (file) ->
    ajaxResponse()
    file.destroyRecord()
  ).then async (file) ->
    equal passedUrl, "/file/1/", "deleting a file makes a DELETE to /file/1/"
    equal passedVerb, "DELETE"

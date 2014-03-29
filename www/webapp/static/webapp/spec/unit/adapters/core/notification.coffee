env = undefined
store = undefined
adapter = undefined
passedUrl = undefined
passedVerb = undefined
passedHash = undefined

module "DS.RESTAdapter / Vosae.NotificationAdapter",
  setup: ->
    env = setupStore()

    # Register transforms
    env.container.register 'transform:datetime', Vosae.DatetimeTransform

    # Register needed adapters & serializers
    env.container.register 'adapter:notification', Vosae.NotificationAdapter
    env.container.register 'serializer:notification', Vosae.NotificationSerializer

    # Make the store and the adapter available for all tests
    store = env.store
    adapter = store.adapterFor 'notification'

    # Reset ajax vars
    passedUrl = null
    passedVerb = null
    passedHash = null

test 'find', ->
  # Setup
  ajaxResponse {id: 1, read: false}

  # Test
  store.find('notification', 1).then async (notif) ->
    equal passedUrl, "/notification/1/", "finding a notification by ID makes a GET to /notification/:id/"
    equal passedVerb, "GET"

    equal notif.get('id'), "1", "the notification's ID is 1"
    equal notif.get('read'), false, "the notification's read property is false"

test 'findAll', ->
  # Setup
  ajaxResponse {objects: [{id: 1, read: false, resource_type: 'contact_saved_ne'}]}

  # Test
  store.find('notification').then async (notifs) ->
    equal passedUrl, "/notification/", "finding notificationd makes a GET to /notification/"
    equal passedVerb, "GET"

    equal notifs.get('length'), 0, "the notification array's should be empty"

    notifs = store.all('contactSavedNE')
    equal notifs.get('length'), 1, "the contactSavedNE array's length should be 1"
    equal notifs.objectAt(0).get('read'), false, "the first notification in the record array is not read"

test 'updateRecord', ->
  # Setup
  store.push 'notification', {id: 1, read: false}

  # Test
  store.find('notification', 1).then(async (notification) ->
    ajaxResponse()
    notification.save()
  ).then async (notification) ->
    equal passedUrl, "/notification/1/mark_as_read/", "updating a notification makes a PUT to /notification/1/mark_as_read/"
    equal passedVerb, "PUT"
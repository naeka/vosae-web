env = undefined
store = undefined
adapter = undefined
passedUrl = undefined
passedVerb = undefined
passedHash = undefined

module "DS.RESTAdapter / Vosae.TimelineAdapter",
  setup: ->
    env = setupStore()

    # Register transforms
    env.container.register 'transform:datetime', Vosae.DatetimeTransform

    # Register needed adapters & serializers
    env.container.register 'adapter:timeline', Vosae.TimelineAdapter
    env.container.register 'serializer:timeline', Vosae.TimelineSerializer

    # Make the store and the adapter available for all tests
    store = env.store
    adapter = store.adapterFor 'timeline'

    # Reset ajax vars
    passedUrl = null
    passedVerb = null
    passedHash = null

test 'find', ->
  # Setup
  ajaxResponse {id: 1, module: 'invoicing'}

  # Test
  store.find('timeline', 1).then async (timeline) ->
    equal passedUrl, "/timeline/1/", "finding a timeline by ID makes a GET to /timeline/:id/"
    equal passedVerb, "GET"

    equal timeline.get('id'), "1", "the timeline's ID is 1"
    equal timeline.get('module'), 'invoicing', "the timeline's module property is invoicing"

test 'findAll', ->
  # Setup
  ajaxResponse {objects: [{id: 1, module: 'invoicing', resource_type: 'contact_saved_te'}]}

  # Test
  store.find('timeline').then async (timelines) ->
    equal passedUrl, "/timeline/", "finding timelined makes a GET to /timeline/"
    equal passedVerb, "GET"

    equal timelines.get('length'), 0, "the timeline array's should be empty"

    timelines = store.all('contactSavedTE')
    equal timelines.get('length'), 1, "the contactSavedTE array's length should be 1"
    equal timelines.objectAt(0).get('module'), 'invoicing', "the first timeline module in the record array is invoicing"

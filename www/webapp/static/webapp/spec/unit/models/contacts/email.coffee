env = undefined
store = undefined

module "DS.Model / Vosae.VosaeEmail",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'method - getErrors', ->
  # Setup
  email = store.createRecord 'vosaeEmail'
  
  # Test
  equal email.getErrors().length => 1, true, "the getErrors method should return an array with at least 1 error"
  
  # Setup
  email.set 'email', 'thomas@email.com'

  # Test
  equal email.getErrors().length, 0, "the getErrors method should return an empty array"

test 'property - type', ->
  # Setup
  email = store.createRecord 'vosaeEmail', {id: 1}

  # Test
  equal email.get('type'), 'WORK', "type default value should be 'WORK'"

test 'computedProperty - displayType', ->
  # Setup
  email = store.createRecord 'vosaeEmail', {id: 1}

  # Test
  equal email.get('displayType'), 'Work', "the displayType property should return 'Work'"

  # Setup
  email.set 'type', 'fakeValue'

  # Test
  equal email.get('displayType'), '', "the displayType property should return an empty string"

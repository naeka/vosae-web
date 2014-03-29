env = undefined
store = undefined

module "DS.Model / Vosae.VosaePhone",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'method - combinedTypeChanged', ->
  # Setup
  phone = store.createRecord 'vosaePhone'
  phone.combinedTypeChanged 'HOME-FAX'

  # Test
  equal phone.get('type'), 'HOME', "the type should be HOME"
  equal phone.get('subtype'), 'FAX', "the subtype should be FAX"

test 'method - getErrors', ->
  # Setup
  phone = store.createRecord 'vosaePhone'
  
  # Test
  equal phone.getErrors().length, 1, "the getErrors method should return an array with 1 error"
  
  # Setup
  phone.set 'phone', '304343043'

  # Test
  equal phone.getErrors().length, 0, "the getErrors method should return an empty array"

test 'computedProperty - typeIsWork', ->
  # Setup
  phone = store.createRecord 'vosaePhone', {type: 'WORK'}

  # Test
  equal phone.get('typeIsWork'), true, "the typeIsWork property should return true"

  # Setup
  phone.set 'type', 'HOME'

  # Test
  equal phone.get('typeIsWork'), false, "the typeIsWork property should return false"

test 'computedProperty - typeIsHome', ->
  # Setup
  phone = store.createRecord 'vosaePhone', {type: 'HOME'}

  # Test
  equal phone.get('typeIsHome'), true, "the typeIsHome property should return true"

  # Setup
  phone.set 'type', 'WORK'

  # Test
  equal phone.get('typeIsHome'), false, "the typeIsHome property should return false"

test 'computedProperty - combinedType', ->
  # Setup
  phone = store.createRecord 'vosaePhone', {type: 'WORK'}

  # Test
  equal phone.get('combinedType'), 'WORK', "the combinedType should return WORK"

  # Setup
  phone.set 'subtype', 'CELL'

  # Test
  equal phone.get('combinedType'), 'WORK-CELL', "the combinedType should return WORK-CELL"

test 'computedProperty - displayCombinedType', ->
  # Setup
  phone = store.createRecord 'vosaePhone', {type: 'WORK'}

  # Test
  equal phone.get('displayCombinedType'), 'Work', "the displayCombinedType should return Work"

  # Setup
  phone.set 'subtype', 'CELL'

  # Test
  equal phone.get('displayCombinedType'), 'Work cell', "the displayCombinedType should return Work cell"

  # Setup
  phone.set 'type', null

  # Test
  equal phone.get('displayCombinedType'), '', "the displayCombinedType should return an empty string"

  # Setup
  phone.set 'subtype', null

  # Test
  equal phone.get('displayCombinedType'), '', "the displayCombinedType should return an empty string"

  # Setup
  phone.set 'type', 'SomethingShity'

  # Test
  equal phone.get('displayCombinedType'), '', "the displayCombinedType should return an empty string"

test 'property - type', ->
  # Setup
  email = store.createRecord 'vosaeEmail', {id: 1}

  # Test
  equal email.get('type'), 'WORK', "type default value should be 'WORK'"
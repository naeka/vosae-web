env = undefined
store = undefined

module "DS.Model / Vosae.File",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'relationship - issuer', ->
  # Setup
  store.push 'user', {id: 1, fullName: 'Thomas Durin'}
  store.push 'file', {id: 1, issuer: 1}

  # Test
  store.find('file', 1).then async (file) ->
    equal file.get('issuer') instanceof Vosae.User, true, "the issuer property should return a user"
    equal file.get('issuer.fullName'), "Thomas Durin", "the issuer should have a name"

test 'computedProperty - displayCreatedAt', ->
  # Setup
  store.push 'file', {id: 1, createdAt: new Date(2011,10,30)}

  # Test
  store.find('file', 1).then async (file) ->
    equal file.get('displayCreatedAt'), "November 30 2011", "the displayCreatedAt property display the createdAt date"

test 'computedProperty - displayModifiedAt', ->
  # Setup
  store.push 'file', {id: 1, modifiedAt: new Date(2011,10,30)}

  # Test
  store.find('file', 1).then async (file) ->
    equal file.get('displayModifiedAt'), "November 30 2011", "the displayModifiedAt property display the modifiedAt date"
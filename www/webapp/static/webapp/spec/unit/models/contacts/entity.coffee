env = undefined
store = undefined

module "DS.Model / Vosae.Entity",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'relationship - addresses', ->
  # Setup
  store.push 'vosaeAddress', {id: 1, country: 'France'}
  store.push 'entity', {id: 1, addresses: [1]}

  # Test
  store.find('entity', 1).then async (entity) ->
    entity.get('addresses').then async (addresses) ->
      equal addresses.objectAt(0) instanceof Vosae.VosaeAddress, true, "the addresses array's first object should be a vosae address"
      equal addresses.objectAt(0).get('country'), "France", "the address should have a country"

      address = addresses.createRecord()
      equal addresses.get('length'), 2
      deepEqual addresses.objectAt(1), address, "it should be possibile to create a new address"

      addresses.removeObject address
      equal addresses.get('length'), 1, "it should be possibile to remove an address"

test 'relationship - emails', ->
  # Setup
  store.push 'vosaeEmail', {id: 1, email: 'thomas@email.com'}
  store.push 'entity', {id: 1, emails: [1]}

  # Test
  store.find('entity', 1).then async (entity) ->
    entity.get('emails').then async (emails) ->
      equal emails.objectAt(0) instanceof Vosae.VosaeEmail, true, "the emails array's first object should be a vosae email"
      equal emails.objectAt(0).get('email'), "thomas@email.com", "the email should have an email"

      email = emails.createRecord()
      equal emails.get('length'), 2
      deepEqual emails.objectAt(1), email, "it should be possibile to create a new email"

      emails.removeObject email
      equal emails.get('length'), 1, "it should be possibile to remove an email"

test 'relationship - phones', ->
  # Setup
  store.push 'vosaePhone', {id: 1, phone: '+33034344'}
  store.push 'entity', {id: 1, phones: [1]}

  # Test
  store.find('entity', 1).then async (entity) ->
    entity.get('phones').then async (phones) ->
      equal phones.objectAt(0) instanceof Vosae.VosaePhone, true, "the phones array's first object should be a vosae phone"
      equal phones.objectAt(0).get('phone'), "+33034344", "the phone should have an phone"

      phone = phones.createRecord()
      equal phones.get('length'), 2
      deepEqual phones.objectAt(1), phone, "it should be possibile to create a new phone"

      phones.removeObject phone
      equal phones.get('length'), 1, "it should be possibile to remove a phone"

test 'relationship - creator', ->
  # Setup
  store.push 'user', {id: 1, fullName: 'Thomas Durin'}
  store.push 'entity', {id: 1, creator: 1}

  # Test
  store.find('entity', 1).then async (entity) ->
    equal entity.get('creator') instanceof Vosae.User, true, "the creator property should return a user"
    equal entity.get('creator.fullName'), "Thomas Durin", "the creator should have a name"

test 'relationship - photo', ->
  # Setup
  store.push 'file', {id: 1, name: 'photo.jpg'}
  store.push 'entity', {id: 1, photo: 1}

  # Test
  store.find('entity', 1).then async (entity) ->
    entity.get('photo').then async (photo) ->
      equal photo instanceof Vosae.File, true, "the photo property should return a file"
      equal photo.get('name'), "photo.jpg", "the photo should have a name"

test 'computedProperty - isOwned', ->
  # Setup
  user1 = store.createRecord 'user'
  user2 = store.createRecord 'user'

  store.get('session').set 'user', user1
  entity = store.createRecord 'entity', {creator: user1}

  # Test
  equal entity.get('isOwned'), true, "the session's user and the entity creator should be the same"

  # Setup
  entity.set 'creator', user2

  # Test
  equal entity.get('isOwned'), false, "the session's user and the entity creator should not be the same"
env = undefined
store = undefined

module "DS.Model / Vosae.VosaeAddress",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'method - recordIsEmpty', ->
  # Setup
  address = store.createRecord 'vosaeAddress'
  
  # Test
  equal address.recordIsEmpty(), true, "the recordIsEmpty method should return true is address is empty"
  
  # Setup
  address.set 'country', 'France'

  # Test
  equal address.recordIsEmpty(), false, "the recordIsEmpty method should return false is address isn't empty"

test 'method - dumpDatafrom', ->
  # Setup
  address = store.createRecord 'vosaeAddress'
  address.setProperties
    type: 'HOME'
    postofficeBox: 'postofficeBox'
    streetAddress: 'streetAddress'
    extendedAddress: 'extendedAddress'
    postalCode: 'postalCode'
    city: 'city'
    state: 'state'
    country: 'country'
  newAddress = store.createRecord 'vosaeAddress'
  newAddress.dumpDataFrom address

  # Test
  equal newAddress.get('type'), 'HOME', "address and newAddress type should be the same"
  equal newAddress.get('postofficeBox'), 'postofficeBox', "address and newAddress postofficeBox should be the same"
  equal newAddress.get('streetAddress'), 'streetAddress', "address and newAddress streetAddress should be the same"
  equal newAddress.get('extendedAddress'), 'extendedAddress', "address and newAddress extendedAddress should be the same"
  equal newAddress.get('postalCode'), 'postalCode', "address and newAddress postalCode should be the same"
  equal newAddress.get('city'), 'city', "address and newAddress city should be the same"
  equal newAddress.get('state'), 'state', "address and newAddress state should be the same"
  equal newAddress.get('country'), 'country', "address and newAddress country should be the same"

test 'property - type', ->
  # Setup
  address = store.push 'vosaeAddress', {id: 1}

  # Test
  equal address.get('type'), 'WORK', "type default value should be 'WORK'"
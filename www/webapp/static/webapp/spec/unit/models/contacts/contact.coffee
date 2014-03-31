env = undefined
store = undefined

module "DS.Model / Vosae.Contact",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'method - getErrors', ->
  # Setup
  contact = store.createRecord 'contact'
  
  # Test
  equal contact.getErrors().length, 2, "the getErrors method should return an array with 2 errors if the contact has no name and no firstname"
  
  # Setup
  contact.set 'firstname', 'Tom'

  # Test
  equal contact.getErrors().length, 1, "the getErrors method should return an array with 1 error if the contact has no name"
  
  # Setup
  contact.set 'name', 'Dale'

  # Test
  equal contact.getErrors().length, 0, "the getErrors method should return an empty array if the contact has a name and a firstname"

test 'relationship - organization', ->
  # Setup
  store.push 'organization', {id: 1, corporateName: 'Naeka'}
  store.push 'contact', {id: 1, organization: 1}

  # Test
  store.find('contact', 1).then async (contact) ->
    contact.get('organization').then async (organization) ->
      equal organization instanceof Vosae.Organization, true, "the organization property should return an organization"
      equal organization.get('corporateName'), "Naeka", "the organization should have a corporate name"

test 'property - civility', ->
  # Setup
  contact = store.createRecord "contact"

  # Test
  equal contact.get('civility'), null, "civility property default value should be null"

test 'computedProperty - fullName', ->
  # Setup
  contact = store.createRecord "contact"

  # Test
  equal contact.get('fullName'), '', "fullName property should return an empty string if there's no name and firstname"

  # Setup
  contact.set 'firstname', 'Tom'

  # Test
  equal contact.get('fullName'), 'Tom', "fullName property should return the firstname if there's no name"

  # Setup
  contact.set 'name', 'Dale'

  # Test
  equal contact.get('fullName'), 'Tom Dale', "fullName property should concat the name and the firstname"

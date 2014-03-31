env = undefined
store = undefined

module "DS.Model / Vosae.Organization",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'method - getErrors', ->
  # Setup
  organization = store.createRecord 'organization'
  
  # Test
  equal organization.getErrors().length, 1, "the getErrors method should return an array with 1 error if the organization has no corporate name"
  
  # Setup
  organization.set 'corporateName', 'Naeka'

  # Test
  equal organization.getErrors().length, 0, "the getErrors method should return an empty array if the organization has a corporate name"

test 'relationship - contacts', ->
  # Setup
  store.push 'contact', {id: 1, name: 'Thomas'}
  store.push 'organization', {id: 1, contacts: [1]}

  # Test
  store.find('organization', 1).then async (organization) ->
    organization.get('contacts').then async (contacts) ->
      equal contacts.objectAt(0) instanceof Vosae.Contact, true, "the contacts array's first object should be a contact"
      equal contacts.objectAt(0).get('name'), "Thomas", "the contact should have an phone"

      contact = contacts.createRecord()
      equal contacts.get('length'), 2
      deepEqual contacts.objectAt(1), contact, "it should be possibile to create a new contact"

      contacts.removeObject contact
      equal contacts.get('length'), 1, "it should be possibile to remove a contact"
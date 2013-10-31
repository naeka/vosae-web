store = null

describe 'Vosae.Contact', ->
  hashContact = 
    additional_names: null
    addresses: []
    birthday: undefined
    civility: null
    emails: []
    firstname: null
    gravatar_mail: null
    name: null
    note: null
    phones: []
    photo_source: null
    photo_uri: null
    private: false
    role: null
    status: null

  beforeEach ->
    comp = getAdapterForTest(Vosae.Contact)
    ajaxUrl = comp[0]
    ajaxType = comp[1]
    ajaxHash = comp[2]
    store = comp[3]

  afterEach ->
    comp = undefined
    ajaxUrl = undefined
    ajaxType = undefined
    ajaxHash = undefined
    store.destroy()

  it 'finding all contact makes a GET to /contact/', ->
    # Setup
    contacts = store.find Vosae.Contact
    
    # Test
    enabledFlags contacts, ['isLoaded', 'isValid'], recordArrayFlags
    expectAjaxURL "/contact/"
    expectAjaxType "GET"

    # Setup
    ajaxHash.success(
      meta: {}
      objects: [$.extend({}, hashContact, {id: 1, firstname: "Tom", name: "Dale"})]
    )
    contact = contacts.objectAt(0)

    # Test
    statesEqual contacts, 'loaded.saved'
    stateEquals contact, 'loaded.saved'
    enabledFlagsForArray contacts, ['isLoaded', 'isValid']
    enabledFlags contact, ['isLoaded', 'isValid']
    expect(contact).toEqual store.find(Vosae.Contact, 1)

  it 'finding a contact by ID makes a GET to /contact/:id/', ->
    # Setup
    contact = store.find Vosae.Contact, 1

    # Test
    stateEquals contact, 'loading'
    enabledFlags contact, ['isLoading', 'isValid']
    expectAjaxType "GET"
    expectAjaxURL "/contact/1/"

    # Setup
    ajaxHash.success($.extend {}, hashContact,
      id: 1
      firstname: "Tom"
      name: "Dale"
      resource_uri: "/api/v1/contact/1/"
    )

    # Test
    stateEquals contact, 'loaded.saved'
    enabledFlags contact, ['isLoaded', 'isValid']
    expect(contact).toEqual store.find(Vosae.Contact, 1)

  it 'finding contacts by query makes a GET to /contact/:query/', ->
    # Setup
    contacts = store.find Vosae.Contact, {name: "Dale", page: 1}

    # Test
    expect(contacts.get('length')).toEqual 0
    enabledFlags contacts, ['isLoading'], recordArrayFlags
    expectAjaxURL "/contact/"
    expectAjaxType "GET"
    expectAjaxData({name: "Dale", page: 1 })

    # Setup
    ajaxHash.success(
      meta: {}
      objects: [
        $.extend {}, hashContact, {id: 1, firstname: "Tom", name: "Dale"}
        $.extend {}, hashContact, {id: 2, firstname: "Marion", name: "Dale"}
      ]
    )
    tom = contacts.objectAt 0
    marion = contacts.objectAt 1

    # Test
    statesEqual [tom, marion], 'loaded.saved'
    enabledFlags contacts, ['isLoaded'], recordArrayFlags
    enabledFlagsForArray [tom, marion], ['isLoaded'], recordArrayFlags
    expect(contacts.get('length')).toEqual 2
    expect(tom.get('firstname')).toEqual "Tom"
    expect(marion.get('firstname')).toEqual "Marion"
    expect(tom.get('id')).toEqual "1"
    expect(marion.get('id')).toEqual "2"

  it 'creating a contact makes a POST to /contact/', ->
    # Setup
    contact = store.createRecord Vosae.Contact, {firstname: "Tom", name: "Dale" }

    # Test
    stateEquals contact, 'loaded.created.uncommitted'
    enabledFlags contact, ['isLoaded', 'isDirty', 'isNew', 'isValid']

    # Setup
    contact.get('transaction').commit()

    # Test
    stateEquals contact, 'loaded.created.inFlight'
    enabledFlags contact, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']
    expectAjaxURL "/contact/"
    expectAjaxType "POST"
    expectAjaxData($.extend {}, hashContact, {firstname: "Tom", name: "Dale"})

    # Setup
    ajaxHash.success($.extend {}, hashContact,
      id: 1
      firstname: "Tom"
      name: "Dale"
      resource_uri: "/api/v1/contact/1/"
    )

    # Test
    stateEquals contact, 'loaded.saved'
    enabledFlags contact, ['isLoaded', 'isValid']
    expect(contact).toEqual store.find(Vosae.Contact, 1)

  it 'updating a contact makes a PUT to /contact/:id/', ->
    # Setup
    store.load Vosae.User, {id: 1}
    store.load Vosae.Contact,
      id: 1
      firstname: "Tom"
      name: "Dale"
      creator: "/api/v1/user/1/"
      status: "ACTIVE"
      private: false
    contact = store.find Vosae.Contact, 1

    # Test
    stateEquals contact, 'loaded.saved' 
    enabledFlags contact, ['isLoaded', 'isValid']

    # Setup
    contact.setProperties {firstname: "Yehuda", name:"Katz"}

    # Test
    stateEquals contact, 'loaded.updated.uncommitted'
    enabledFlags contact, ['isLoaded', 'isDirty', 'isValid']

    # Setup
    contact.get('transaction').commit()

    # Test
    stateEquals contact, 'loaded.updated.inFlight'
    enabledFlags contact, ['isLoaded', 'isDirty', 'isSaving', 'isValid']
    expectAjaxURL "/contact/1/"
    expectAjaxType "PUT"
    expectAjaxData($.extend {}, hashContact,
      firstname: "Yehuda"
      name:"Katz"
      creator: "/api/v1/user/1/"
      status: "ACTIVE"
    )

    # Setup
    ajaxHash.success($.extend {}, hashContact,
      id: 1
      firstname: "Yehuda", 
      name:"Katz",
      creator: "/api/v1/user/1", 
      status: "ACTIVE"
      private: false
    )

    # Test
    stateEquals contact, 'loaded.saved'
    enabledFlags contact, ['isLoaded', 'isValid']
    expect(contact).toEqual store.find(Vosae.Contact, 1)
    expect(contact.get('firstname')).toEqual 'Yehuda'

  it 'deleting a contact makes a DELETE to /contact/:id/', ->
    # Setup
    store.load Vosae.Contact, {id: 1, firstname: "Tom", name: "Dale"}
    contact = store.find Vosae.Contact, 1

    # Test
    stateEquals contact, 'loaded.saved' 
    enabledFlags contact, ['isLoaded', 'isValid']

    # Setup
    contact.deleteRecord()

    # Test
    stateEquals contact, 'deleted.uncommitted'
    enabledFlags contact, ['isLoaded', 'isDirty', 'isDeleted', 'isValid']

    # Setup
    contact.get('transaction').commit()

    # Test
    stateEquals contact, 'deleted.inFlight'
    enabledFlags contact, ['isLoaded', 'isDirty', 'isSaving', 'isDeleted', 'isValid']
    expectAjaxURL "/contact/1/"
    expectAjaxType "DELETE"

    # Setup
    ajaxHash.success()

    # Test
    stateEquals contact, 'deleted.saved'
    enabledFlags contact, ['isLoaded', 'isDeleted', 'isValid']

  it 'civility property should be null when creating contact', ->
    # Setup
    contact = store.createRecord Vosae.Contact

    # Test
    expect(contact.get('civility')).toEqual null

  it 'fullName property should concat firstname and name', ->
    # Setup
    store.load Vosae.Contact, {id: 1}
    contact = store.find Vosae.Contact, 1

    # Test
    expect(contact.get('fullName')).toEqual ''

    # Setup
    contact.set 'firstname', 'Tom'

    # Test
    expect(contact.get('fullName')).toEqual 'Tom'

    # Setup
    contact.set 'name', 'Dale'

    # Test
    expect(contact.get('fullName')).toEqual 'Tom Dale'

  it 'organization belongsTo relationship', ->
    # Setup
    store.load Vosae.Organization, {id: 1, corporate_name: "Emberjs"}
    store.load Vosae.Contact, {id: 1, organization: "/api/v1/organization/1/"}
    contact = store.find Vosae.Contact, 1

    # Test
    expect(contact.get('organization.corporateName')).toEqual "Emberjs"
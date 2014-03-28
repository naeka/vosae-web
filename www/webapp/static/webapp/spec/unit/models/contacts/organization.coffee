# store = null

# describe 'Vosae.Organization', ->
#   hashOrganization = 
#     addresses: []
#     contacts: []
#     corporate_name: null
#     emails: []
#     gravatar_mail: null
#     note: null
#     phones: []
#     photo_source: null
#     photo_uri: null
#     private: false
#     status: null

#   beforeEach ->
#     comp = getAdapterForTest(Vosae.Organization)
#     ajaxUrl = comp[0]
#     ajaxType = comp[1]
#     ajaxHash = comp[2]
#     store = comp[3]

#   afterEach ->
#     comp = undefined
#     ajaxUrl = undefined
#     ajaxType = undefined
#     ajaxHash = undefined
#     store.destroy()

#   it 'finding all organization makes a GET to /organization/', ->
#     # Setup
#     organizations = store.find Vosae.Organization
    
#     # Test
#     enabledFlags organizations, ['isLoaded', 'isValid'], recordArrayFlags
#     expectAjaxURL "/organization/"
#     expectAjaxType "GET"

#     # Setup
#     ajaxHash.success(
#       meta: {}
#       objects: [$.extend({}, hashOrganization, {id:1, corporateName: "Naeka"})]
#     )
#     organization = organizations.objectAt(0)

#     # Test
#     statesEqual organizations, 'loaded.saved'
#     stateEquals organization, 'loaded.saved'
#     enabledFlagsForArray organizations, ['isLoaded', 'isValid']
#     enabledFlags organization, ['isLoaded', 'isValid']
#     expect(organization).toEqual store.find(Vosae.Organization, 1)

#   it 'finding a organization by ID makes a GET to /organization/:id/', ->
#     # Setup
#     organization = store.find Vosae.Organization, 1

#     # Test
#     stateEquals organization, 'loading'
#     enabledFlags organization, ['isLoading', 'isValid']
#     expectAjaxType "GET"
#     expectAjaxURL "/organization/1/"

#     # Setup
#     ajaxHash.success($.extend {}, hashOrganization,
#       id: 1
#       corporateName: "Naeka"
#       resource_uri: "/api/v1/organization/1/"
#     )

#     # Test
#     stateEquals organization, 'loaded.saved'
#     enabledFlags organization, ['isLoaded', 'isValid']
#     expect(organization).toEqual store.find(Vosae.Organization, 1)

#   it 'finding organizations by query makes a GET to /organization/:query/', ->
#     # Setup
#     organizations = store.find Vosae.Organization, {corporateName: "Naeka", page: 1}

#     # Test
#     expect(organizations.get('length')).toEqual 0
#     enabledFlags organizations, ['isLoading'], recordArrayFlags
#     expectAjaxURL "/organization/"
#     expectAjaxType "GET"
#     expectAjaxData({corporateName: "Naeka", page: 1 })

#     # Setup
#     ajaxHash.success(
#       meta: {}
#       objects: [
#         $.extend {}, hashOrganization, {id: 1, corporate_name: "Naeka"}
#       ]
#     )
#     naeka = organizations.objectAt 0

#     # Test
#     statesEqual [naeka], 'loaded.saved'
#     enabledFlags organizations, ['isLoaded'], recordArrayFlags
#     enabledFlagsForArray [naeka], ['isLoaded'], recordArrayFlags
#     expect(organizations.get('length')).toEqual 1
#     expect(naeka.get('corporateName')).toEqual "Naeka"
#     expect(naeka.get('id')).toEqual "1"

#   it 'creating a organization makes a POST to /organization/', ->
#     # Setup
#     organization = store.createRecord Vosae.Organization, {corporateName: "Naeka"}

#     # Test
#     stateEquals organization, 'loaded.created.uncommitted'
#     enabledFlags organization, ['isLoaded', 'isDirty', 'isNew', 'isValid']

#     # Setup
#     organization.get('transaction').commit()

#     # Test
#     stateEquals organization, 'loaded.created.inFlight'
#     enabledFlags organization, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']
#     expectAjaxURL "/organization/"
#     expectAjaxType "POST"
#     expectAjaxData($.extend {}, hashOrganization, {corporate_name: "Naeka"})

#     # Setup
#     ajaxHash.success($.extend {}, hashOrganization,
#       id: 1
#       corporateName: "Naeka"
#       resource_uri: "/api/v1/organization/1/"
#     )

#     # Test
#     stateEquals organization, 'loaded.saved'
#     enabledFlags organization, ['isLoaded', 'isValid']
#     expect(organization).toEqual store.find(Vosae.Organization, 1)

#   it 'updating a organization makes a PUT to /organization/:id/', ->
#     # Setup
#     store.load Vosae.User, {id: 1}
#     store.load Vosae.Organization,
#       id: 1
#       corporateName: "Naeka"
#       creator: "/api/v1/user/1/"
#       status: "ACTIVE"
#       private: false
#     organization = store.find Vosae.Organization, 1

#     # Test
#     stateEquals organization, 'loaded.saved' 
#     enabledFlags organization, ['isLoaded', 'isValid']

#     # Setup
#     organization.setProperties {corporateName: "NaekaCorp"}

#     # Test
#     stateEquals organization, 'loaded.updated.uncommitted'
#     enabledFlags organization, ['isLoaded', 'isDirty', 'isValid']

#     # Setup
#     organization.get('transaction').commit()

#     # Test
#     stateEquals organization, 'loaded.updated.inFlight'
#     enabledFlags organization, ['isLoaded', 'isDirty', 'isSaving', 'isValid']
#     expectAjaxURL "/organization/1/"
#     expectAjaxType "PUT"
#     expectAjaxData($.extend {}, hashOrganization,
#       corporate_name: "NaekaCorp"
#       creator: "/api/v1/user/1/"
#       status: "ACTIVE"
#     )

#     # Setup
#     ajaxHash.success($.extend {}, hashOrganization,
#       id: 1
#       corporate_name: "NaekaCorp"
#       creator: "/api/v1/user/1"
#       status: "ACTIVE"
#       private: false
#     )

#     # Test
#     stateEquals organization, 'loaded.saved'
#     enabledFlags organization, ['isLoaded', 'isValid']
#     expect(organization).toEqual store.find(Vosae.Organization, 1)
#     expect(organization.get('corporateName')).toEqual 'NaekaCorp'

#   it 'deleting a organization makes a DELETE to /organization/:id/', ->
#     # Setup
#     store.load Vosae.Organization, {id: 1, corporateName: "Naeka"}
#     organization = store.find Vosae.Organization, 1

#     # Test
#     stateEquals organization, 'loaded.saved' 
#     enabledFlags organization, ['isLoaded', 'isValid']

#     # Setup
#     organization.deleteRecord()

#     # Test
#     stateEquals organization, 'deleted.uncommitted'
#     enabledFlags organization, ['isLoaded', 'isDirty', 'isDeleted', 'isValid']

#     # Setup
#     organization.get('transaction').commit()

#     # Test
#     stateEquals organization, 'deleted.inFlight'
#     enabledFlags organization, ['isLoaded', 'isDirty', 'isSaving', 'isDeleted', 'isValid']
#     expectAjaxURL "/organization/1/"
#     expectAjaxType "DELETE"

#     # Setup
#     ajaxHash.success()

#     # Test
#     stateEquals organization, 'deleted.saved'
#     enabledFlags organization, ['isLoaded', 'isDeleted', 'isValid']

#   it 'can add contacts', ->
#     # Setup
#     store.load Vosae.Organization, {id: 1}
#     organization = store.find Vosae.Organization, 1
#     contact = organization.get('contacts').createRecord Vosae.Contact
#     contact2 = organization.get('contacts').createRecord Vosae.Contact    

#     # Test
#     expect(organization.get('contacts.length')).toEqual 2
#     expect(organization.get('contacts').objectAt(0)).toEqual contact
#     expect(organization.get('contacts').objectAt(1)).toEqual contact2

#   it 'can delete contacts', ->
#     # Setup
#     store.load Vosae.Organization, {id: 1}
#     organization = store.find Vosae.Organization, 1
#     contact = organization.get('contacts').createRecord Vosae.Contact
#     contact2 = organization.get('contacts').createRecord Vosae.Contact

#     # Test
#     expect(organization.get('contacts.length')).toEqual 2

#     # Setup
#     organization.get('contacts').removeObject contact
#     organization.get('contacts').removeObject contact2

#     # Test
#     expect(organization.get('contacts.length')).toEqual 0
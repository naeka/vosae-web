# store = null

# describe 'Vosae.RegistrationInfo', ->
#   hashRegistrationInfo =
#     business_entity: null
#     share_capital: null

#   beforeEach ->
#     store = Vosae.Store.create()

#   afterEach ->
#     store.destroy()

#   it 'registrationInfoFor() method should return the right model according to the country code', ->
#     # Setup
#     registrationInfo = Vosae.RegistrationInfo.createRecord()

#     # Test
#     expect(registrationInfo.registrationInfoFor('BE')).toEqual Vosae.BeRegistrationInfo
#     expect(registrationInfo.registrationInfoFor('CH')).toEqual Vosae.ChRegistrationInfo
#     expect(registrationInfo.registrationInfoFor('FR')).toEqual Vosae.FrRegistrationInfo
#     expect(registrationInfo.registrationInfoFor('GB')).toEqual Vosae.GbRegistrationInfo
#     expect(registrationInfo.registrationInfoFor('LU')).toEqual Vosae.LuRegistrationInfo
#     expect(registrationInfo.registrationInfoFor('US')).toEqual Vosae.UsRegistrationInfo



#   it 'polymorph be_registration_info', ->
#     # Setup
#     store.adapterForType(Vosae.Tenant).load store, Vosae.Tenant, 
#       id: 1
#       registration_info:
#         business_entity: "SARL"
#         share_capital: "1200,00"
#         resource_type: "be_registration_info"
#         vat_number: "30303030"
#     tenant = store.find Vosae.Tenant, 1

#     # Test
#     expect(tenant.get('registrationInfo.countryCode')).toEqual 'BE'
#     expect(tenant.get('registrationInfo.businessEntity')).toEqual "SARL"
#     expect(tenant.get('registrationInfo.shareCapital')).toEqual "1200,00"
#     expect(tenant.get('registrationInfo.vatNumber')).toEqual "30303030"

#   it 'polymorph ch_registration_info', ->
#     # Setup
#     store.adapterForType(Vosae.Tenant).load store, Vosae.Tenant, 
#       id: 1
#       registration_info:
#         business_entity: "SARL"
#         share_capital: "1200,00"
#         resource_type: "ch_registration_info"
#         vat_number: "30303030"
#     tenant = store.find Vosae.Tenant, 1

#     # Test
#     expect(tenant.get('registrationInfo.countryCode')).toEqual 'CH'
#     expect(tenant.get('registrationInfo.businessEntity')).toEqual "SARL"
#     expect(tenant.get('registrationInfo.shareCapital')).toEqual "1200,00"
#     expect(tenant.get('registrationInfo.vatNumber')).toEqual "30303030"

#   it 'polymorph fr_registration_info', ->
#     # Setup
#     store.adapterForType(Vosae.Tenant).load store, Vosae.Tenant, 
#       id: 1
#       registration_info:
#         business_entity: "SARL"
#         share_capital: "1200,00"
#         resource_type: "fr_registration_info"
#         vat_number: "30303030"
#         siret: "12345"
#         rcs_number: "6780"
#     tenant = store.find Vosae.Tenant, 1

#     # Test
#     expect(tenant.get('registrationInfo.countryCode')).toEqual 'FR'
#     expect(tenant.get('registrationInfo.businessEntity')).toEqual "SARL"
#     expect(tenant.get('registrationInfo.shareCapital')).toEqual "1200,00"
#     expect(tenant.get('registrationInfo.vatNumber')).toEqual "30303030"
#     expect(tenant.get('registrationInfo.siret')).toEqual "12345"
#     expect(tenant.get('registrationInfo.rcsNumber')).toEqual "6780"

#   it 'polymorph gb_registration_info', ->
#     # Setup
#     store.adapterForType(Vosae.Tenant).load store, Vosae.Tenant, 
#       id: 1
#       registration_info:
#         business_entity: "SARL"
#         share_capital: "1200,00"
#         resource_type: "gb_registration_info"
#         vat_number: "30303030"
#     tenant = store.find Vosae.Tenant, 1

#     # Test
#     expect(tenant.get('registrationInfo.countryCode')).toEqual 'GB'
#     expect(tenant.get('registrationInfo.businessEntity')).toEqual "SARL"
#     expect(tenant.get('registrationInfo.shareCapital')).toEqual "1200,00"
#     expect(tenant.get('registrationInfo.vatNumber')).toEqual "30303030"


#   it 'polymorph lu_registration_info', ->
#     # Setup
#     store.adapterForType(Vosae.Tenant).load store, Vosae.Tenant, 
#       id: 1
#       registration_info:
#         business_entity: "SARL"
#         share_capital: "1200,00"
#         resource_type: "lu_registration_info"
#         vat_number: "30303030"
#     tenant = store.find Vosae.Tenant, 1

#     # Test
#     expect(tenant.get('registrationInfo.countryCode')).toEqual 'LU'
#     expect(tenant.get('registrationInfo.businessEntity')).toEqual "SARL"
#     expect(tenant.get('registrationInfo.shareCapital')).toEqual "1200,00"
#     expect(tenant.get('registrationInfo.vatNumber')).toEqual "30303030"

#   it 'polymorph us_registration_info', ->
#     # Setup
#     store.adapterForType(Vosae.Tenant).load store, Vosae.Tenant, 
#       id: 1
#       registration_info:
#         business_entity: "SARL"
#         share_capital: "1200,00"
#         resource_type: "us_registration_info"
#     tenant = store.find Vosae.Tenant, 1

#     # Test
#     expect(tenant.get('registrationInfo.countryCode')).toEqual 'US'
#     expect(tenant.get('registrationInfo.businessEntity')).toEqual "SARL"
#     expect(tenant.get('registrationInfo.shareCapital')).toEqual "1200,00"

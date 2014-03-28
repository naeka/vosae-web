get = Ember.get
set = Ember.set
env = undefined

module "DS.Model / Vosae.Tenant",
  setup: ->
    env = setupStore
      reportSettings: Vosae.ReportSettings
      tenant: Vosae.Tenant
      registrationInfo: Vosae.RegistrationInfo
      vosaeAddress: Vosae.VosaeAddress
      file: Vosae.File
      user: Vosae.User
    # Hack to be able to use the typeKey property
    env.store.modelFor(Vosae.Tenant)
    return env

test 'relationship - registrationInfo', ->
  # Setup
  store = env.store
  store.push 'registrationInfo', {id: 1, businessEntity: 'SARL'}
  store.push 'tenant', {id: 1, registrationInfo: 1, registrationInfoType: 'registrationInfo' }

  # Test
  store.find('tenant', 1).then async (tenant) ->
    equal get(tenant, 'registrationInfo') instanceof Vosae.RegistrationInfo, true, "the registrationInfo property should return a registration info"
    equal get(tenant, 'registrationInfo.businessEntity'), "SARL", "the registration info should have a business entity"

test 'relationship - reportSettings', ->
  # Setup
  store = env.store
  store.push 'reportSettings', {id: 1, fontName: 'bariol'}
  store.push 'tenant', {id: 1, reportSettings: 1}

  # Test
  store.find('tenant', 1).then async (tenant) ->
    equal get(tenant, 'reportSettings') instanceof Vosae.ReportSettings, true, "the reportSettings property should return a report settings"
    equal get(tenant, 'reportSettings.fontName'), "bariol", "the report settings should have a font name"

test 'relationship - postalAddress', ->
  # Setup
  store = env.store
  store.push 'vosaeAddress', {id: 1, country: 'France'}
  store.push 'tenant', {id: 1, postalAddress: 1}

  # Test
  store.find('tenant', 1).then async (tenant) ->
    equal get(tenant, 'postalAddress') instanceof Vosae.VosaeAddress, true, "the postalAddress property should return a vosae address"
    equal get(tenant, 'postalAddress.country'), "France", "the postal address should have a country"

test 'relationship - billingAddress', ->
  # Setup
  store = env.store
  store.push 'vosaeAddress', {id: 1, country: 'France'}
  store.push 'tenant', {id: 1, billingAddress: 1}

  # Test
  store.find('tenant', 1).then async (tenant) ->
    equal get(tenant, 'billingAddress') instanceof Vosae.VosaeAddress, true, "the billingAddress property should return a vosae address"
    equal get(tenant, 'billingAddress.country'), "France", "the billing address should have a country"

test 'relationship - svgLogo', ->
  # Setup
  store = env.store
  store.push 'file', {id: 1, name: 'myLogo.svg'}
  store.push 'tenant', {id: 1, svgLogo: 1}

  # Test
  store.find('tenant', 1).then async (tenant) ->
    equal get(tenant, 'svgLogo') instanceof Vosae.File, true, "the svgLogo property should return a file"
    equal get(tenant, 'svgLogo.name'), "myLogo.svg", "the svg logo should have name"

test 'relationship - imgLogo', ->
  # Setup
  store = env.store
  store.push 'file', {id: 1, name: 'myImage.png'}
  store.push 'tenant', {id: 1, imgLogo: 1}

  # Test
  store.find('tenant', 1).then async (tenant) ->
    equal get(tenant, 'imgLogo') instanceof Vosae.File, true, "the imgLogo property should return a file"
    equal get(tenant, 'imgLogo.name'), "myImage.png", "the img logo should have name"

test 'relationship - terms', ->
  # Setup
  store = env.store
  store.push 'file', {id: 1, name: 'myTerms.pdf'}
  store.push 'tenant', {id: 1, terms: 1}

  # Test
  store.find('tenant', 1).then async (tenant) ->
    equal get(tenant, 'terms') instanceof Vosae.File, true, "the terms property should return a file"
    equal get(tenant, 'terms.name'), "myTerms.pdf", "the terms should have name"

# test 'find tenants', ->
#   # Setup
#   env.container.register 'adapter:tenant', Vosae.TenantAdapter
#   env.container.register 'serializer:tenant', Vosae.TenantSerializer

#   store = env.store
#   adapter = store.adapterFor 'tenant'
#   adapter.ajax = (url, type, hash) ->
#     expectAjaxURL url, "/tenant/", "finding tenants makes a GET to /tenant/"
#     Ember.RSVP.resolve({objects: []})

#   store.find('tenant').then async (tenants) ->
#     equal 1, 1

  # # Test
  # enabledFlags tenants, ['isLoaded', 'isValid'], recordArrayFlags
  # expectAjaxURL "/tenant/"
  # expectAjaxType "GET"

  # # Setup
  # ajaxHash.success(
  #   meta: {}
  #   objects: [$.extend({}, hashTenant, {id: 1, name: "Naeka"})]
  # )
  # tenant = tenants.objectAt(0)

  # # Test
  # statesEqual tenants, 'loaded.saved'
  # stateEquals tenant, 'loaded.saved'
  # enabledFlagsForArray tenants, ['isLoaded', 'isValid']
  # enabledFlags tenant, ['isLoaded', 'isValid']
  # expect(tenant).toEqual store.find(Vosae.Tenant, 1)

#   it 'finding a tenant by ID makes a GET to /tenant/:id/', ->
#     # Setup
#     tenant = store.find Vosae.Tenant, 1

#     # Test
#     stateEquals tenant, 'loading'
#     enabledFlags tenant, ['isLoading', 'isValid']
#     expectAjaxType "GET"
#     expectAjaxURL "/tenant/1/"

#     # Setup
#     ajaxHash.success($.extend {}, hashTenant,
#       id: 1
#       name: "Naeka"
#       resource_uri: "/api/v1/tenant/1/"
#     )

#     # Test
#     stateEquals tenant, 'loaded.saved'
#     enabledFlags tenant, ['isLoaded', 'isValid']
#     expect(tenant).toEqual store.find(Vosae.Tenant, 1)

#   it 'finding tenants by query makes a GET to /tenant/:query/', ->
#     # Setup
#     tenants = store.find Vosae.Tenant, {page: 1}

#     # Test
#     expect(tenants.get('length')).toEqual 0
#     enabledFlags tenants, ['isLoading'], recordArrayFlags
#     expectAjaxURL "/tenant/"
#     expectAjaxType "GET"
#     expectAjaxData({page: 1 })

#     # Setup
#     ajaxHash.success(
#       meta: {}
#       objects: [
#         $.extend({}, hashTenant, {id: 1, name: "Naeka"})
#         $.extend({}, hashTenant, {id: 2, name: "Vosae",})
#       ]
#     )
#     naeka = tenants.objectAt 0
#     vosae = tenants.objectAt 1

#     # Test
#     statesEqual [naeka, vosae], 'loaded.saved'
#     enabledFlags tenants, ['isLoaded'], recordArrayFlags
#     enabledFlagsForArray [naeka, vosae], ['isLoaded'], recordArrayFlags
#     expect(tenants.get('length')).toEqual 2
#     expect(naeka.get('name')).toEqual "Naeka"
#     expect(vosae.get('name')).toEqual "Vosae"
#     expect(naeka.get('id')).toEqual "1"
#     expect(vosae.get('id')).toEqual "2"

#   it 'creating a tenant makes a POST to /tenant/', ->
#     # Setup
#     store.adapterForType(Vosae.Currency).load store, Vosae.Currency, {id: 1, symbol: "EUR", resource_uri: "/api/v1/currency/1/"}
#     store.adapterForType(Vosae.Currency).load store, Vosae.Currency, {id: 2, symbol: "USD", resource_uri: "/api/v1/currency/2/"}
#     eur = store.find Vosae.Currency, 1
#     usd = store.find Vosae.Currency, 2
#     tenant = store.createRecord Vosae.Tenant, {name: "Naeka"}
#     controller = Vosae.lookup('controller:tenants.add')
#     controller.setProperties
#       supportedCurrencies: [eur, usd]
#       defaultCurrency: eur

#     # Test
#     stateEquals tenant, 'loaded.created.uncommitted'
#     enabledFlags tenant, ['isLoaded', 'isDirty', 'isNew', 'isValid']

#     # Setup
#     tenant.get('transaction').commit()

#     # Test
#     stateEquals tenant, 'loaded.created.inFlight'
#     enabledFlags tenant, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']
#     expectAjaxURL "/tenant/"
#     expectAjaxType "POST"
#     expectAjaxData $.extend({}, hashTenant, 
#       name: "Naeka"
#       supported_currencies:['/api/v1/currency/1/', '/api/v1/currency/2/']
#       default_currency: '/api/v1/currency/1/'
#     )

#     # Setup
#     ajaxHash.success($.extend {}, hashTenant,
#       id: 1
#       name: "Naeka"
#     )

#     # Test
#     stateEquals tenant, 'loaded.saved'
#     enabledFlags tenant, ['isLoaded', 'isValid']
#     expect(tenant).toEqual store.find(Vosae.Tenant, 1)

#   it 'updating a tenant makes a PUT to /tenant/:id/', ->
#     # Setup
#     store.adapterForType(Vosae.Tenant).load store, Vosae.Tenant, {id: 1, name: "Naeka"}
#     tenant = store.find Vosae.Tenant, 1

#     # Test
#     stateEquals tenant, 'loaded.saved' 
#     enabledFlags tenant, ['isLoaded', 'isValid']

#     # Setup
#     tenant.setProperties {name: "Vosae"}

#     # Test
#     stateEquals tenant, 'loaded.updated.uncommitted'
#     enabledFlags tenant, ['isLoaded', 'isDirty', 'isValid']

#     # Setup
#     tenant.get('transaction').commit()

#     # Test
#     stateEquals tenant, 'loaded.updated.inFlight'
#     enabledFlags tenant, ['isLoaded', 'isDirty', 'isSaving', 'isValid']
#     expectAjaxURL "/tenant/1/"
#     expectAjaxType "PUT"
#     expectAjaxData($.extend {}, hashTenant,
#       name: "Vosae"
#     )

#     # Setup
#     ajaxHash.success($.extend {}, hashTenant,
#       id: 1
#       name: "Vosae"
#     )

#     # Test
#     stateEquals tenant, 'loaded.saved'
#     enabledFlags tenant, ['isLoaded', 'isValid']
#     expect(tenant).toEqual store.find(Vosae.Tenant, 1)
#     expect(tenant.get('name')).toEqual 'Vosae'





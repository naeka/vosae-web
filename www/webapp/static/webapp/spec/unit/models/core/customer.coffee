store = null

describe 'Vosae.Tenant', ->
  hashTenant =
    billing_address: null
    email: null
    fax: null
    name: null
    phone: null
    postal_address: null
    registration_info: null
    report_settings: null
    slug: null

  beforeEach ->
    comp = getAdapterForTest(Vosae.Tenant)
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

  it 'finding all tenants makes a GET to /tenant/', ->
    # Setup
    tenants = store.find Vosae.Tenant

    # Test
    enabledFlags tenants, ['isLoaded', 'isValid'], recordArrayFlags
    expectAjaxURL "/tenant/"
    expectAjaxType "GET"

    # Setup
    ajaxHash.success(
      meta: {}
      objects: [$.extend({}, hashTenant, {id: 1, name: "Naeka"})]
    )
    tenant = tenants.objectAt(0)

    # Test
    statesEqual tenants, 'loaded.saved'
    stateEquals tenant, 'loaded.saved'
    enabledFlagsForArray tenants, ['isLoaded', 'isValid']
    enabledFlags tenant, ['isLoaded', 'isValid']
    expect(tenant).toEqual store.find(Vosae.Tenant, 1)

  it 'finding a tenant by ID makes a GET to /tenant/:id/', ->
    # Setup
    tenant = store.find Vosae.Tenant, 1

    # Test
    stateEquals tenant, 'loading'
    enabledFlags tenant, ['isLoading', 'isValid']
    expectAjaxType "GET"
    expectAjaxURL "/tenant/1/"

    # Setup
    ajaxHash.success($.extend {}, hashTenant,
      id: 1
      name: "Naeka"
      resource_uri: "/api/v1/tenant/1/"
    )

    # Test
    stateEquals tenant, 'loaded.saved'
    enabledFlags tenant, ['isLoaded', 'isValid']
    expect(tenant).toEqual store.find(Vosae.Tenant, 1)

  it 'finding tenants by query makes a GET to /tenant/:query/', ->
    # Setup
    tenants = store.find Vosae.Tenant, {page: 1}

    # Test
    expect(tenants.get('length')).toEqual 0
    enabledFlags tenants, ['isLoading'], recordArrayFlags
    expectAjaxURL "/tenant/"
    expectAjaxType "GET"
    expectAjaxData({page: 1 })

    # Setup
    ajaxHash.success(
      meta: {}
      objects: [
        $.extend({}, hashTenant, {id: 1, name: "Naeka"})
        $.extend({}, hashTenant, {id: 2, name: "Vosae",})
      ]
    )
    naeka = tenants.objectAt 0
    vosae = tenants.objectAt 1

    # Test
    statesEqual [naeka, vosae], 'loaded.saved'
    enabledFlags tenants, ['isLoaded'], recordArrayFlags
    enabledFlagsForArray [naeka, vosae], ['isLoaded'], recordArrayFlags
    expect(tenants.get('length')).toEqual 2
    expect(naeka.get('name')).toEqual "Naeka"
    expect(vosae.get('name')).toEqual "Vosae"
    expect(naeka.get('id')).toEqual "1"
    expect(vosae.get('id')).toEqual "2"

  it 'creating a tenant makes a POST to /tenant/', ->
    # Setup
    store.adapterForType(Vosae.Currency).load store, Vosae.Currency, {id: 1, symbol: "EUR", resource_uri: "/api/v1/currency/1/"}
    store.adapterForType(Vosae.Currency).load store, Vosae.Currency, {id: 2, symbol: "USD", resource_uri: "/api/v1/currency/2/"}
    eur = store.find Vosae.Currency, 1
    usd = store.find Vosae.Currency, 2
    tenant = store.createRecord Vosae.Tenant, {name: "Naeka"}
    controller = Vosae.lookup('controller:tenants.add')
    controller.setProperties
      supportedCurrencies: [eur, usd]
      defaultCurrency: eur

    # Test
    stateEquals tenant, 'loaded.created.uncommitted'
    enabledFlags tenant, ['isLoaded', 'isDirty', 'isNew', 'isValid']

    # Setup
    tenant.get('transaction').commit()

    # Test
    stateEquals tenant, 'loaded.created.inFlight'
    enabledFlags tenant, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']
    expectAjaxURL "/tenant/"
    expectAjaxType "POST"
    expectAjaxData $.extend({}, hashTenant, 
      name: "Naeka"
      supported_currencies:['/api/v1/currency/1/', '/api/v1/currency/2/']
      default_currency: '/api/v1/currency/1/'
    )

    # Setup
    ajaxHash.success($.extend {}, hashTenant,
      id: 1
      name: "Naeka"
    )

    # Test
    stateEquals tenant, 'loaded.saved'
    enabledFlags tenant, ['isLoaded', 'isValid']
    expect(tenant).toEqual store.find(Vosae.Tenant, 1)

  it 'updating a tenant makes a PUT to /tenant/:id/', ->
    # Setup
    store.adapterForType(Vosae.Tenant).load store, Vosae.Tenant, {id: 1, name: "Naeka"}
    tenant = store.find Vosae.Tenant, 1

    # Test
    stateEquals tenant, 'loaded.saved' 
    enabledFlags tenant, ['isLoaded', 'isValid']

    # Setup
    tenant.setProperties {name: "Vosae"}

    # Test
    stateEquals tenant, 'loaded.updated.uncommitted'
    enabledFlags tenant, ['isLoaded', 'isDirty', 'isValid']

    # Setup
    tenant.get('transaction').commit()

    # Test
    stateEquals tenant, 'loaded.updated.inFlight'
    enabledFlags tenant, ['isLoaded', 'isDirty', 'isSaving', 'isValid']
    expectAjaxURL "/tenant/1/"
    expectAjaxType "PUT"
    expectAjaxData($.extend {}, hashTenant,
      name: "Vosae"
    )

    # Setup
    ajaxHash.success($.extend {}, hashTenant,
      id: 1
      name: "Vosae"
    )

    # Test
    stateEquals tenant, 'loaded.saved'
    enabledFlags tenant, ['isLoaded', 'isValid']
    expect(tenant).toEqual store.find(Vosae.Tenant, 1)
    expect(tenant.get('name')).toEqual 'Vosae'

  it 'registrationInfo belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.Tenant).load store, Vosae.Tenant, 
      id: 1
      registration_info:
        business_entity: "SARL"
        share_capital: "1200.00"
        vat_number: null
        siret: null
        rcs_number: null
        resource_type: "fr_registration_info"
    tenant = store.find Vosae.Tenant, 1

    # Test
    expect(tenant.get('registrationInfo.businessEntity')).toEqual "SARL"

  it 'reportSettings belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.Tenant).load store, Vosae.Tenant, 
      id: 1
      report_settings:
        font_name: "arial"
        font_size: 15
        base_color: "#CCC"
        force_bw: true
        language: "fr"
    tenant = store.find Vosae.Tenant, 1

    # Test
    expect(tenant.get('reportSettings.fontName')).toEqual "arial"

  it 'postalAddress belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.Tenant).load store, Vosae.Tenant, 
      id: 1
      postal_address:
        postoffice_box: ""
        street_address: "streetAddress"
        extended_address: ""
        postal_code: ""
        city: ""
        state: ""
        country: ""
    tenant = store.find Vosae.Tenant, 1

    # Test
    expect(tenant.get('postalAddress.streetAddress')).toEqual "streetAddress"

  it 'billingAddress belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.Tenant).load store, Vosae.Tenant, 
      id: 1
      billing_address:
        postoffice_box: ""
        street_address: "streetAddress"
        extended_address: ""
        postal_code: ""
        city: ""
        state: ""
        country: ""
    tenant = store.find Vosae.Tenant, 1

    # Test
    expect(tenant.get('billingAddress.streetAddress')).toEqual "streetAddress"

  it 'svgLogo belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.File).load store, Vosae.File, {id: 1}
    file = store.find Vosae.File, 1
    store.adapterForType(Vosae.Tenant).load store, Vosae.Tenant, {id: 1, svg_logo: '/api/v1/file/1/'}
    tenant = store.find Vosae.Tenant, 1

    # Test
    expect(tenant.get('svgLogo')).toEqual file

  it 'imgLogo belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.File).load store, Vosae.File, {id: 1}
    file = store.find Vosae.File, 1
    store.adapterForType(Vosae.Tenant).load store, Vosae.Tenant, {id: 1, img_logo: '/api/v1/file/1/'}
    tenant = store.find Vosae.Tenant, 1

    # Test
    expect(tenant.get('imgLogo')).toEqual file

  it 'terms belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.File).load store, Vosae.File, {id: 1}
    file = store.find Vosae.File, 1
    store.adapterForType(Vosae.Tenant).load store, Vosae.Tenant, {id: 1, terms: '/api/v1/file/1/'}
    tenant = store.find Vosae.Tenant, 1

    # Test
    expect(tenant.get('terms')).toEqual file
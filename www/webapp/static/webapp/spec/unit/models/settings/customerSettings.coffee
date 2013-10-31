store = null

describe 'Vosae.TenantSettings', ->
  hashTenantSettings = 
    core: null
    invoicing: null

  beforeEach ->
    comp = getAdapterForTest(Vosae.TenantSettings)
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

  it 'finding a tenant settings by ID makes a GET to /tenant_settings/:id/', ->
    # Setup
    tenantSettings = store.find Vosae.TenantSettings, 1

    # Test
    stateEquals tenantSettings, 'loading'
    enabledFlags tenantSettings, ['isLoading', 'isValid']
    expectAjaxType "GET"
    expectAjaxURL "/tenant_settings/"

    # Setup
    ajaxHash.success($.extend {}, hashTenantSettings,
      id: 1
    )

    # Test
    stateEquals tenantSettings, 'loaded.saved'
    enabledFlags tenantSettings, ['isLoaded', 'isValid']
    expect(tenantSettings).toEqual store.find(Vosae.TenantSettings, 1)

  it 'updating a tenantSettings makes a PUT to /tenant_settings/', ->
    # Setup
    store.adapterForType(Vosae.TenantSettings).load store, Vosae.TenantSettings, {id: 1, invoicing: {payment_conditions: "CASH"}}
    tenantSettings = store.find Vosae.TenantSettings, 1

    # Test
    stateEquals tenantSettings, 'loaded.saved' 
    enabledFlags tenantSettings, ['isLoaded', 'isValid']

    # Setup
    tenantSettings.set 'invoicing', null

    # Test
    stateEquals tenantSettings, 'loaded.updated.uncommitted'
    enabledFlags tenantSettings, ['isLoaded', 'isDirty', 'isValid']

    # Setup
    tenantSettings.get('transaction').commit()

    # Test
    stateEquals tenantSettings, 'loaded.updated.inFlight'
    enabledFlags tenantSettings, ['isLoaded', 'isDirty', 'isSaving', 'isValid']
    expectAjaxURL "/tenant_settings/"
    expectAjaxType "PUT"
    expectAjaxData($.extend {}, hashTenantSettings,
      invoicing: null
    )

    # Setup
    ajaxHash.success($.extend {}, hashTenantSettings,
      id: 1
    )

    # Test
    stateEquals tenantSettings, 'loaded.saved'
    enabledFlags tenantSettings, ['isLoaded', 'isValid']
    expect(tenantSettings).toEqual store.find(Vosae.TenantSettings, 1)

  it 'invoicing belongsTo embedded relationship', ->
    # Setup
    store.adapterForType(Vosae.TenantSettings).load store, Vosae.TenantSettings, {id: 1, invoicing: {payment_conditions: "CASH"}}
    tenantSettings = store.find Vosae.TenantSettings, 1

    # Test
    expect(tenantSettings.get('invoicing.paymentConditions')).toEqual 'CASH'


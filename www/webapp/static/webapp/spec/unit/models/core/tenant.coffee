env = undefined
store = undefined

module "DS.Model / Vosae.Tenant",
  setup: ->
    env = setupStore()
    
    # Make the store available for all tests
    store = env.store

test 'relationship - registrationInfo', ->
  # Setup
  store.push 'registrationInfo', {id: 1, businessEntity: 'SARL'}
  store.push 'tenant', {id: 1, registrationInfo: 1, registrationInfoType: 'registrationInfo' }

  # Test
  store.find('tenant', 1).then async (tenant) ->
    equal tenant.get('registrationInfo') instanceof Vosae.RegistrationInfo, true, "the registrationInfo property should return a registration info"
    equal tenant.get('registrationInfo.businessEntity'), "SARL", "the registration info should have a business entity"

test 'relationship - reportSettings', ->
  # Setup
  store.push 'reportSettings', {id: 1, fontName: 'bariol'}
  store.push 'tenant', {id: 1, reportSettings: 1}

  # Test
  store.find('tenant', 1).then async (tenant) ->
    equal tenant.get('reportSettings') instanceof Vosae.ReportSettings, true, "the reportSettings property should return a report settings"
    equal tenant.get('reportSettings.fontName'), "bariol", "the report settings should have a font name"

test 'relationship - postalAddress', ->
  # Setup
  store.push 'vosaeAddress', {id: 1, country: 'France'}
  store.push 'tenant', {id: 1, postalAddress: 1}

  # Test
  store.find('tenant', 1).then async (tenant) ->
    equal tenant.get('postalAddress') instanceof Vosae.VosaeAddress, true, "the postalAddress property should return a vosae address"
    equal tenant.get('postalAddress.country'), "France", "the postal address should have a country"

test 'relationship - billingAddress', ->
  # Setup
  store.push 'vosaeAddress', {id: 1, country: 'France'}
  store.push 'tenant', {id: 1, billingAddress: 1}

  # Test
  store.find('tenant', 1).then async (tenant) ->
    equal tenant.get('billingAddress') instanceof Vosae.VosaeAddress, true, "the billingAddress property should return a vosae address"
    equal tenant.get('billingAddress.country'), "France", "the billing address should have a country"

test 'relationship - svgLogo', ->
  # Setup
  store.push 'file', {id: 1, name: 'myLogo.svg'}
  store.push 'tenant', {id: 1, svgLogo: 1}

  # Test
  store.find('tenant', 1).then async (tenant) ->
    equal tenant.get('svgLogo') instanceof Vosae.File, true, "the svgLogo property should return a file"
    equal tenant.get('svgLogo.name'), "myLogo.svg", "the svg logo should have name"

test 'relationship - imgLogo', ->
  # Setup
  store.push 'file', {id: 1, name: 'myImage.png'}
  store.push 'tenant', {id: 1, imgLogo: 1}

  # Test
  store.find('tenant', 1).then async (tenant) ->
    equal tenant.get('imgLogo') instanceof Vosae.File, true, "the imgLogo property should return a file"
    equal tenant.get('imgLogo.name'), "myImage.png", "the img logo should have name"

test 'relationship - terms', ->
  # Setup
  store.push 'file', {id: 1, name: 'myTerms.pdf'}
  store.push 'tenant', {id: 1, terms: 1}

  # Test
  store.find('tenant', 1).then async (tenant) ->
    equal tenant.get('terms') instanceof Vosae.File, true, "the terms property should return a file"
    equal tenant.get('terms.name'), "myTerms.pdf", "the terms should have name"

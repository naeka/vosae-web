env = undefined
store = undefined
adapter = undefined
passedUrl = undefined
passedVerb = undefined
passedHash = undefined

module "DS.RESTAdapter / Vosae.TenantAdapter",
  setup: ->
    env = setupStore()

    # Register needed adapters & serializers
    env.container.register 'adapter:tenant', Vosae.TenantAdapter
    env.container.register 'serializer:tenant', Vosae.TenantSerializer

    # Make the store and the adapter available for all tests
    store = env.store
    adapter = store.adapterFor 'tenant'

    # Reset ajax vars
    passedUrl = null
    passedVerb = null
    passedHash = null

test 'find', ->
  # Setup
  ajaxResponse {id: 1, slug: 'naeka'}

  # Test
  store.find('tenant', 1).then async (tenant) ->
    equal passedUrl, "/tenant/1/", "finding a tenant by ID makes a GET to /tenant/:id/"
    equal passedVerb, "GET"

    equal tenant.get('id'), "1", "the tenant's ID is 1"
    equal tenant.get('slug'), "naeka", "the tenant's slug is naeka"

test 'findAll', ->
  # Setup
  ajaxResponse {objects: [{id: 1, slug: 'naeka'}]}

  # Test
  store.find('tenant').then async (tenants) ->
    equal passedUrl, "/tenant/", "finding tenants makes a GET to /tenant/"
    equal passedVerb, "GET"

    equal tenants.get('length'), 1, "the tenants array's length is 1 after a record is loaded into it"
    equal tenants.objectAt(0).get('slug'), 'naeka', "the first tenant in the record array is naeka"

test 'createRecord', ->
  # Setup
  env.container.register 'controller:tenantsShow', Ember.ArrayController
  env.container.register 'controller:tenantsAdd', Vosae.TenantsAddController
  env.container.register 'serializer:currency', Vosae.CurrencySerializer
  env.container.register 'model:currency', Vosae.Currency
  env.container.register 'model:exchangeRate', Vosae.ExchangeRate

  eur = store.createRecord 'currency', {resourceURI: '/currency/1/'}
  usd = store.createRecord 'currency', {resourceURI: '/currency/2/'}

  controller = env.container.lookup('controller:tenantsAdd')
  controller.setProperties
    'defaultCurrency': eur
    'supportedCurrencies': [eur, usd]

  ajaxResponse {id: 1, slug: 'naeka'}

  # Test
  store.createRecord('tenant').save().then async (tenant) ->
    equal passedUrl, "/tenant/", "creating a tenant makes a POST to /tenant/"
    equal passedVerb, "POST"

    deepEqual passedHash.data['supported_currencies'], ['/currency/1/', '/currency/2/']
    equal passedHash.data['default_currency'], '/currency/1/'

test 'updateRecord', ->
  # Setup
  store.push 'tenant', {id: 1, slug: 'naeka'}

  # Test
  store.find('tenant', 1).then(async (tenant) ->
    ajaxResponse()
    tenant.save()
  ).then async (tenant) ->
    equal passedUrl, "/tenant/1/", "updating a tenant makes a PUT to /tenant/1/"
    equal passedVerb, "PUT"

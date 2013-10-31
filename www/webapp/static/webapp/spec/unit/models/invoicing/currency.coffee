store = null

describe 'Vosae.Currency', ->
  hashCurrency = 
    symbol: null
    rates: []
    resource_uri: null

  beforeEach ->
    comp = getAdapterForTest(Vosae.Currency)
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

  it 'finding all currency makes a GET to /currency/', ->
    # Setup
    currencies = store.find Vosae.Currency
    
    # Test
    enabledFlags currencies, ['isLoaded', 'isValid'], recordArrayFlags
    expectAjaxURL "/currency/"
    expectAjaxType "GET"

    # Setup
    ajaxHash.success(
      meta: {}
      objects: [$.extend({}, hashCurrency, {id: 1, symbol: "EUR"})]
    )
    currency = currencies.objectAt(0)

    # Test
    statesEqual currencies, 'loaded.saved'
    stateEquals currency, 'loaded.saved'
    enabledFlagsForArray currencies, ['isLoaded', 'isValid']
    enabledFlags currency, ['isLoaded', 'isValid']
    expect(currency).toEqual store.find(Vosae.Currency, 1)

  it 'finding a currency by ID makes a GET to /currency/:id/', ->
    # Setup
    currency = store.find Vosae.Currency, 1

    # Test
    stateEquals currency, 'loading'
    enabledFlags currency, ['isLoading', 'isValid']
    expectAjaxType "GET"
    expectAjaxURL "/currency/1/"

    # Setup
    ajaxHash.success($.extend {}, hashCurrency,
      id: 1
      symbol: "EUR"
      rates: []
      resource_uri: "/api/v1/currency/1/"
    )

    # Test
    stateEquals currency, 'loaded.saved'
    enabledFlags currency, ['isLoaded', 'isValid']
    expect(currency).toEqual store.find(Vosae.Currency, 1)

  it 'finding currencies by query makes a GET to /currency/:query/', ->
    # Setup
    currencies = store.find Vosae.Currency, {page: 1}

    # Test
    expect(currencies.get('length')).toEqual 0
    enabledFlags currencies, ['isLoading'], recordArrayFlags
    expectAjaxURL "/currency/"
    expectAjaxType "GET"
    expectAjaxData({page: 1 })

    # Setup
    ajaxHash.success(
      meta: {}
      objects: [
        $.extend {}, hashCurrency, {id: 1, symbol: "EUR", resource_uri: "/api/v1/currency/1/"}
        $.extend {}, hashCurrency, {id: 2, symbol: "USD", resource_uri: "/api/v1/currency/2/"}
      ]
    )
    eur = currencies.objectAt 0
    usd = currencies.objectAt 1

    # Test
    statesEqual [eur, usd], 'loaded.saved'
    enabledFlags currencies, ['isLoaded'], recordArrayFlags
    enabledFlagsForArray [eur, usd], ['isLoaded'], recordArrayFlags
    expect(currencies.get('length')).toEqual 2
    expect(eur.get('symbol')).toEqual "EUR"
    expect(usd.get('symbol')).toEqual "USD"
    expect(eur.get('id')).toEqual "1"
    expect(usd.get('id')).toEqual "2"

  it 'description property should return the currency\'s description', ->
    # Setup
    store.load Vosae.Currency, {id: 1, symbol: "SOMETHINGSHITTY"}
    currency = store.find Vosae.Currency, 1

    # Test
    expect(currency.get('description')).toEqual ''

    # Setup
    currency.set 'symbol', 'EUR'

    # Test
    expect(currency.get('description')).toEqual 'Euro'

  it 'displaySign property should return the currency\'s sign', ->
    # Setup
    store.load Vosae.Currency, {id: 1, symbol: ""}
    currency = store.find Vosae.Currency, 1

    # Test
    expect(currency.get('displaySign')).toEqual ''

    # Setup
    currency.set 'symbol', 'EUR'

    # Test
    expect(currency.get('displaySign')).toEqual '€'

  it 'displaySignWithSymbol property should return the currency\'s sign with symbol', ->
    # Setup
    store.load Vosae.Currency, {id: 1, symbol: ""}
    currency = store.find Vosae.Currency, 1

    # Test
    expect(currency.get('displaySignWithSymbol')).toEqual ''

    # Setup
    currency.set 'symbol', 'EUR'

    # Test
    expect(currency.get('displaySignWithSymbol')).toEqual '€ - EUR'

  it 'exchangeRateFor() should return the exchangeRate associated to the specified symbol', ->
    # Setup
    store.adapterForType(Vosae.Currency).load store, Vosae.Currency,
      id: 1
      symbol: "EUR"
      rates: [
        {
          currency_to: "USD"
          datetime: "2013-07-23T12:01:00+00:00"
          rate: "1.32"
        },
        {
          currency_to: "JPY"
          datetime: "2013-07-23T12:01:00+00:00"
          rate: "0.3"
        }
      ]
    currency = store.find Vosae.Currency, 1
    rateUSD = currency.get('rates').objectAt(0) 

    # Test
    expect(currency.exchangeRateFor('USD')).toEqual rateUSD

  it 'toCurrency() method should convert an amount from a currency to another, based on the rates', ->
    # Setup
    store.adapterForType(Vosae.Currency).load store, Vosae.Currency,
      id: 1
      symbol: "EUR"
      rates: [{
        currency_to: "USD",
        datetime: "2013-07-23T12:01:00+00:00"
        rate: "1.32"
      }]
    currency = store.find Vosae.Currency, 1

    # Test
    expect(currency.toCurrency('USD', 10).round(2)).toEqual 13.2

  it 'fromCurrency() method should convert an amount from a currency to another, based on the rates', ->
    # Setup
    store.adapterForType(Vosae.Currency).load store, Vosae.Currency,
      id: 1
      symbol: "EUR"
      rates: [{
        currency_to: "USD",
        datetime: "2013-07-23T12:01:00+00:00"
        rate: "1.32"
      }]
    currency = store.find Vosae.Currency, 1

    # Test
    expect(currency.fromCurrency('USD', 132)).toEqual 100
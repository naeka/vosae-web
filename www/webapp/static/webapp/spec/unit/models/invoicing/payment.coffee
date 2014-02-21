store = null

describe 'Vosae.Payment', ->
  expectedPostData =
    amount: 1000
    type: "CASH"
    date: "2013-08-10"
    currency: "/api/v1/currency/1/"
    related_to: "/api/v1/invoice/1/"
    note: "bah"

  beforeEach ->
    comp = getAdapterForTest(Vosae.Payment)
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

  it 'finding a payment by ID makes a GET to /payment/:id/', ->
    # Setup
    payment = store.find Vosae.Payment, 1

    # Test
    stateEquals payment, 'loading'
    enabledFlags payment, ['isLoading', 'isValid']
    expectAjaxType "GET"
    expectAjaxURL "/payment/1/"

    # Setup
    ajaxHash.success(
      id: 1
      resource_uri: "/api/v1/payment/1/"
    )

    # Test
    stateEquals payment, 'loaded.saved'
    enabledFlags payment, ['isLoaded', 'isValid']
    expect(payment).toEqual store.find(Vosae.Payment, 1)

  it 'creating a payment makes a POST to /payment/', ->
    # Setup
    store.adapterForType(Vosae.Currency).load store, Vosae.Currency, {id: 1}
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    payment = store.createRecord Vosae.Payment, {}
    payment.setProperties
      'amount': 1000
      'type': 'CASH'
      'date': (new Date(2013, 7, 10))
      'currency': store.find(Vosae.Currency, 1)
      'relatedTo': store.find(Vosae.Invoice, 1)
      'note': 'bah'

    # Test
    stateEquals payment, 'loaded.created.uncommitted'
    enabledFlags payment, ['isLoaded', 'isDirty', 'isNew', 'isValid']

    # Setup
    payment.get('transaction').commit()

    # Test
    stateEquals payment, 'loaded.created.inFlight'
    enabledFlags payment, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']
    expectAjaxURL "/payment/"
    expectAjaxType "POST"
    expectAjaxData(expectedPostData)

    # Setup
    ajaxHash.success($.extend {}, expectedPostData,
      id: 1
      resource_uri: "/api/v1/payment/1/"
    )

    # Test
    stateEquals payment, 'loaded.saved'
    enabledFlags payment, ['isLoaded', 'isValid']
    expect(payment).toEqual store.find(Vosae.Payment, 1)

  it 'displayDate property should return the date formated', ->
    # Setup
    store.adapterForType(Vosae.Payment).load store, Vosae.Payment, {id: 1}
    payment = store.find Vosae.Payment, 1
    
    # Test
    expect(payment.get('displayDate')).toEqual "undefined"

    # Setup
    payment.set "date", (new Date(2013, 7, 10))

    # Test
    expect(payment.get('displayDate')).toEqual "August 10 2013"

  it 'displayAmount property should return the amount formated', ->
    # Setup
    store.adapterForType(Vosae.Payment).load store, Vosae.Payment, {id: 1}
    payment = store.find Vosae.Payment, 1
    
    # Test
    expect(payment.get('displayAmount')).toEqual ""

    # Setup
    payment.set "amount", 1000

    # Test
    expect(payment.get('displayAmount')).toEqual "1,000.00"

  it 'displayType property should return the type formated', ->
    # Setup
    store.adapterForType(Vosae.Payment).load store, Vosae.Payment, {id: 1}
    payment = store.find Vosae.Payment, 1
    
    # Test
    expect(payment.get('displayType')).toEqual "undefined"
    Vosae.Config.paymentTypes.forEach (type) ->
      payment.set 'type', type.get('value')
      expect(payment.get('displayType')).toEqual type.get('label')

  it 'displayNote property should return the note or -', ->
    # Setup
    store.adapterForType(Vosae.Payment).load store, Vosae.Payment, {id: 1}
    payment = store.find Vosae.Payment, 1
    
    # Test
    expect(payment.get('displayNote')).toEqual "-"

    # Setup
    payment.set "note", "my note"

    # Test
    expect(payment.get('displayNote')).toEqual "my note"

  it 'amountMax property should return the amount maximum for the payment', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, 
      id: 1
      balance: 1000
      current_revision:
        currency:
          symbol: "EUR"
          rates: [
            {
              currency_to: "USD"
              rate: "2"
            },
            {
              currency_to: "EUR"
              rate: "1"
            }
          ]
    store.adapterForType(Vosae.Currency).load store, Vosae.Currency, {id: 1, symbol: "USD"}
    currency = store.find Vosae.Currency, 1
    store.adapterForType(Vosae.Payment).load store, Vosae.Payment, {id: 1, currency: "/api/v1/currency/1/", related_to: "/api/v1/invoice/1/"}
    payment = store.find Vosae.Payment, 1

    # Test
    expect(payment.get('amountMax')).toEqual 2000.00

    # Setup
    payment.get('currency').set "symbol", "EUR"

    # Test
    expect(payment.get('amountMax')).toEqual 1000.00

  it 'updateWithCurrency() method shold convert the amount according to the new currency', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, 
      id: 1
      balance: 1000
      current_revision:
        currency:
          symbol: "EUR"
          rates: [
            {
              currency_to: "USD"
              rate: "2"
            },
            {
              currency_to: "EUR"
              rate: "1"
            }
          ]
    store.adapterForType(Vosae.Currency).load store, Vosae.Currency, {id: 1, symbol: "USD"}
    usd = store.find Vosae.Currency, 1
    store.adapterForType(Vosae.Currency).load store, Vosae.Currency, {id: 2, symbol: "EUR"}
    eur = store.find Vosae.Currency, 2

    store.adapterForType(Vosae.Payment).load store, Vosae.Payment, {id: 1, currency: "/api/v1/currency/1/", related_to: "/api/v1/invoice/1/", amount: 2000}
    payment = store.find Vosae.Payment, 1
    payment.updateWithCurrency(eur)

    # Test
    expect(payment.get('amount')).toEqual 1000.00

    # Setup
    payment.updateWithCurrency(usd)

    # Test
    expect(payment.get('amount')).toEqual 2000.00
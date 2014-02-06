store = null

describe 'Vosae.InvoiceRevision', ->
  beforeEach ->
    store = Vosae.Store.create()

  afterEach ->
    store.destroy()

  it 'lineItems hasMany relationship', ->
    # Setup
    store.adapterForType(Vosae.InvoiceRevision).load store, Vosae.InvoiceRevision,
      id: 1
      lineItems: [
        {ref:"Book"}
      ]
    invoiceRevision = store.find Vosae.InvoiceRevision, 1
    book = invoiceRevision.get('lineItems').objectAt(0)

    # Test
    expect(invoiceRevision.get('lineItems.firstObject')).toEqual book

  it 'can add lineItem', ->
    # Setup
    store.adapterForType(Vosae.InvoiceRevision).load store, Vosae.InvoiceRevision, {id: 1}
    invoiceRevision = store.find Vosae.InvoiceRevision, 1
    lineItem = invoiceRevision.get('lineItems').createRecord Vosae.LineItem
    lineItem2 = invoiceRevision.get('lineItems').createRecord Vosae.LineItem    

    # Test
    expect(invoiceRevision.get('lineItems.length')).toEqual 2
    expect(invoiceRevision.get('lineItems').objectAt(0)).toEqual lineItem
    expect(invoiceRevision.get('lineItems').objectAt(1)).toEqual lineItem2

  it 'can delete lineItem', ->
    # Setup
    store.adapterForType(Vosae.InvoiceRevision).load store, Vosae.InvoiceRevision, {id: 1}
    invoiceRevision = store.find Vosae.InvoiceRevision, 1
    lineItem = invoiceRevision.get('lineItems').createRecord Vosae.LineItem
    lineItem2 = invoiceRevision.get('lineItems').createRecord Vosae.LineItem

    # Test
    expect(invoiceRevision.get('lineItems.length')).toEqual 2

    # Setup
    invoiceRevision.get('lineItems').removeObject lineItem
    invoiceRevision.get('lineItems').removeObject lineItem2

    # Test
    expect(invoiceRevision.get('lineItems.length')).toEqual 0

  it 'pdf belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.File).load store, Vosae.File, {id: 1}
    file = store.find Vosae.File, 1
    store.adapterForType(Vosae.InvoiceRevision).load store, Vosae.InvoiceRevision, {id: 1, pdf: {fr:"/api/v1/file/1/"}}
    invoiceRevision = store.find Vosae.InvoiceRevision, 1

    # Test
    expect(invoiceRevision.get('pdf.fr')).toEqual file

  it 'organization belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.Organization).load store, Vosae.Organization, {id: 1}
    organization = store.find Vosae.Organization, 1
    store.adapterForType(Vosae.InvoiceRevision).load store, Vosae.InvoiceRevision, {id: 1, organization: "/api/v1/organization/1/"}
    invoiceRevision = store.find Vosae.InvoiceRevision, 1

    # Test
    expect(invoiceRevision.get('organization')).toEqual organization

  it 'contact belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.Contact).load store, Vosae.Contact, {id: 1}
    contact = store.find Vosae.Contact, 1
    store.adapterForType(Vosae.InvoiceRevision).load store, Vosae.InvoiceRevision, {id: 1, contact: "/api/v1/contact/1/"}
    invoiceRevision = store.find Vosae.InvoiceRevision, 1

    # Test
    expect(invoiceRevision.get('contact')).toEqual contact

  it 'issuer belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.User).load store, Vosae.User, {id: 1}
    issuer = store.find Vosae.User, 1
    store.adapterForType(Vosae.InvoiceRevision).load store, Vosae.InvoiceRevision, {id: 1, issuer: "/api/v1/issuer/1/"}
    invoiceRevision = store.find Vosae.InvoiceRevision, 1

    # Test
    expect(invoiceRevision.get('issuer')).toEqual issuer

  it 'currency belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.InvoiceRevision).load store, Vosae.InvoiceRevision, {id: 1, currency: {symbol:"EUR"}}
    invoiceRevision = store.find Vosae.InvoiceRevision, 1

    # Test
    expect(invoiceRevision.get('currency.symbol')).toEqual "EUR"

  it 'senderAddress belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.InvoiceRevision).load store, Vosae.InvoiceRevision, {id: 1, sender_address: {country:"France"}}
    invoiceRevision = store.find Vosae.InvoiceRevision, 1

    # Test
    expect(invoiceRevision.get('senderAddress.country')).toEqual "France"

  it 'billingAddress belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.InvoiceRevision).load store, Vosae.InvoiceRevision, {id: 1, billing_address: {country:"France"}}
    invoiceRevision = store.find Vosae.InvoiceRevision, 1

    # Test
    expect(invoiceRevision.get('billingAddress.country')).toEqual "France"

  it 'deliveryAddress belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.InvoiceRevision).load store, Vosae.InvoiceRevision, {id: 1, delivery_address: {country:"France"}}
    invoiceRevision = store.find Vosae.InvoiceRevision, 1

    # Test
    expect(invoiceRevision.get('deliveryAddress.country')).toEqual "France"

  it 'displayQuotationDate property should format the quotationDate', ->
    # Setup
    store.adapterForType(Vosae.InvoiceRevision).load store, Vosae.InvoiceRevision, {id: 1, quotation_date: "2013-07-17T14:51:37+02:00"}
    invoiceRevision = store.find Vosae.InvoiceRevision, 1

    # Test
    expect(invoiceRevision.get('displayQuotationDate')).toEqual "July 17 2013"

    # Setup
    invoiceRevision.set 'quotationDate', null

    # Test
    expect(invoiceRevision.get('displayQuotationDate')).toEqual "undefined"

  it 'displayQuotationValidity property should format the quotationValidity', ->
    # Setup
    store.adapterForType(Vosae.InvoiceRevision).load store, Vosae.InvoiceRevision, {id: 1, quotation_validity: "2013-07-17T14:51:37+02:00"}
    invoiceRevision = store.find Vosae.InvoiceRevision, 1

    # Test
    expect(invoiceRevision.get('displayQuotationValidity')).toEqual "July 17 2013"

    # Setup
    invoiceRevision.set 'quotationValidity', null

    # Test
    expect(invoiceRevision.get('displayQuotationValidity')).toEqual "undefined"
 
  it 'displayInvoicingDate property should format the invoicingDate', ->
    # Setup
    store.adapterForType(Vosae.InvoiceRevision).load store, Vosae.InvoiceRevision, {id: 1, invoicing_date: "2013-07-17T14:51:37+02:00"}
    invoiceRevision = store.find Vosae.InvoiceRevision, 1

    # Test
    expect(invoiceRevision.get('displayInvoicingDate')).toEqual "July 17 2013"

    # Setup
    invoiceRevision.set 'invoicingDate', null

    # Test
    expect(invoiceRevision.get('displayInvoicingDate')).toEqual "undefined"

  it 'displayCreditNoteEmissionDate property should format the creditNoteEmissionDate', ->
    # Setup
    store.adapterForType(Vosae.InvoiceRevision).load store, Vosae.InvoiceRevision, {id: 1, credit_note_emission_date: "2013-07-17T14:51:37+02:00"}
    invoiceRevision = store.find Vosae.InvoiceRevision, 1

    # Test
    expect(invoiceRevision.get('displayCreditNoteEmissionDate')).toEqual "July 17 2013"

    # Setup
    invoiceRevision.set 'creditNoteEmissionDate', null

    # Test
    expect(invoiceRevision.get('displayCreditNoteEmissionDate')).toEqual "undefined"

  it 'displayPurchaseOrderDate property should format the purchaseOrderDate', ->
    # Setup
    store.adapterForType(Vosae.InvoiceRevision).load store, Vosae.InvoiceRevision, {id: 1, purchase_order_date: "2013-07-17T14:51:37+02:00"}
    invoiceRevision = store.find Vosae.InvoiceRevision, 1

    # Test
    expect(invoiceRevision.get('displayPurchaseOrderDate')).toEqual "July 17 2013"

    # Setup
    invoiceRevision.set 'purchaseOrderDate', null

    # Test
    expect(invoiceRevision.get('displayPurchaseOrderDate')).toEqual "undefined"

  it 'displayDueDate property should format the dueDate', ->
    # Setup
    store.adapterForType(Vosae.InvoiceRevision).load store, Vosae.InvoiceRevision, {id: 1}
    invoiceRevision = store.find Vosae.InvoiceRevision, 1

    # Test
    expect(invoiceRevision.get('displayDueDate')).toEqual "undefined"

    # Setup
    invoiceRevision.set 'customPaymentConditions', "30 days"

    # Test
    expect(invoiceRevision.get('displayDueDate')).toEqual "variable"
   
    # Setup
    invoiceRevision.set 'dueDate', (new Date(2013, 6, 17))

    # Test
    expect(invoiceRevision.get('displayDueDate')).toEqual "variable (July 17 2013)"

    # Setup
    invoiceRevision.set 'customPaymentConditions', null

    # Test
    expect(invoiceRevision.get('displayDueDate')).toEqual "July 17 2013"
  
  it 'total property should add the total of each lineItems', ->
    # Setup
    store.adapterForType(Vosae.InvoiceRevision).load store, Vosae.InvoiceRevision,
      id: 1
      line_items: [
        {unit_price: 10.46, quantity: 2},
        {unit_price: 5.30, quantity: 10}
      ]
    invoiceRevision = store.find Vosae.InvoiceRevision, 1

    # Test
    expect(invoiceRevision.get('total')).toEqual 73.92

  it 'totalPlusTax property should add the total with taxes of each lineItems', ->
    # Setup
    store.adapterForType(Vosae.Tax).load store, Vosae.Tax, {id:1, rate: 0.10}
    store.adapterForType(Vosae.Tax).load store, Vosae.Tax, {id:2, rate: 0.20}
    store.adapterForType(Vosae.InvoiceRevision).load store, Vosae.InvoiceRevision,
      id: 1
      line_items: [
        {unit_price: 10.46, quantity: 2, tax: "/api/v1/tax/1/"},
        {unit_price: 5.30, quantity: 10, tax: "/api/v1/tax/2/"}
      ]
    invoiceRevision = store.find Vosae.InvoiceRevision, 1

    # Test
    expect(invoiceRevision.get('totalPlusTax')).toEqual 86.612

  it 'displayTotal property should format and round the total', ->
    # Setup
    store.adapterForType(Vosae.InvoiceRevision).load store, Vosae.InvoiceRevision,
      id: 1
      line_items: [
        {unit_price: 10.46, quantity: 2},
        {unit_price: 5.30, quantity: 10}
      ]
    invoiceRevision = store.find Vosae.InvoiceRevision, 1

    # Test
    expect(invoiceRevision.get('displayTotal')).toEqual "73.92"

  it 'dispayTotalPlusTax property should format and round the totalPlusTax', ->
    # Setup
    store.adapterForType(Vosae.Tax).load store, Vosae.Tax, {id:1, rate: 0.10}
    store.adapterForType(Vosae.Tax).load store, Vosae.Tax, {id:2, rate: 0.20}
    store.adapterForType(Vosae.InvoiceRevision).load store, Vosae.InvoiceRevision,
      id: 1
      line_items: [
        {unit_price: 10.46, quantity: 2, tax: "/api/v1/tax/1/"},
        {unit_price: 5.30, quantity: 10, tax: "/api/v1/tax/2/"}
      ]
    invoiceRevision = store.find Vosae.InvoiceRevision, 1

    # Test
    expect(invoiceRevision.get('displayTotalPlusTax')).toEqual "86.61"

  it 'taxes property should return a dict with total amount for each taxes', ->
    # Setup
    store.adapterForType(Vosae.Tax).load store, Vosae.Tax, {id:1, rate: 0.10}
    store.adapterForType(Vosae.Tax).load store, Vosae.Tax, {id:2, rate: 0.20}
    store.adapterForType(Vosae.InvoiceRevision).load store, Vosae.InvoiceRevision,
      id: 1
      line_items: [
        {unit_price: 10, quantity: 1, tax: "/api/v1/tax/1/"},
        {unit_price: 4, quantity: 2, tax: "/api/v1/tax/1/"},
        {unit_price: 5, quantity: 3, tax: "/api/v1/tax/2/"}
      ]
    invoiceRevision = store.find Vosae.InvoiceRevision, 1
    taxes = invoiceRevision.get('taxes')

    # Test
    expect(taxes.objectAt(0).total).toEqual 1.8
    expect(taxes.objectAt(0).tax).toEqual store.find(Vosae.Tax, 1)
    expect(taxes.objectAt(1).total).toEqual 3
    expect(taxes.objectAt(1).tax).toEqual store.find(Vosae.Tax, 2)

  it '_getLineItemsReferences() method should return an array of itemID related to the lineItems', ->
    # Setup
    store.adapterForType(Vosae.InvoiceRevision).load store, Vosae.InvoiceRevision,
      id: 1
      line_items: [
        {item_id: "1"},
        {item_id: "2"},
        {item_id: "3"},
        {item_id: "1"}
      ]
    invoiceRevision = store.find Vosae.InvoiceRevision, 1

    # Test
    expect(invoiceRevision._getLineItemsReferences()).toEqual ["1", "2", "3"]

  it '_userOverrodeUnitPrice() method should return true if orginial unit price has been overrode', ->
    # Setup
    store.adapterForType(Vosae.Currency).load store, Vosae.Currency, {id: 1, symbol: "EUR"}
    store.adapterForType(Vosae.Item).load store, Vosae.Item, {id:1, unit_price: 10, currency: "/api/v1/currency/1/"}
    store.adapterForType(Vosae.InvoiceRevision).load store, Vosae.InvoiceRevision,
      id: 1
      currency: {     
        symbol: "EUR" 
        rates: [
          {currency_to: "EUR", rate: "1.00"},
          {currency_to: "USD", rate: "2.00"}
        ]
      }
      line_items: [
        {item_id: "1", unit_price: 10},
      ]
    invoiceRevision = store.find Vosae.InvoiceRevision, 1
    lineItem = invoiceRevision.get('lineItems').objectAt(0)
    invoiceCurrency = invoiceRevision.get('currency')
    item = store.find Vosae.Item, 1
    itemCurrency = item.get('currency')

    # Test
    expect(invoiceRevision._userOverrodeUnitPrice(lineItem, item, invoiceCurrency)).toEqual false

    # Setup
    lineItem.set 'unitPrice', 20

    # Test
    expect(invoiceRevision._userOverrodeUnitPrice(lineItem, item, invoiceCurrency)).toEqual true

    # Setup
    itemCurrency.set 'symbol', 'USD'
    lineItem.set 'unitPrice', 5

    # Test
    expect(invoiceRevision._userOverrodeUnitPrice(lineItem, item, invoiceCurrency)).toEqual false

    # Setup
    lineItem.set 'unitPrice', 10

    # Test
    expect(invoiceRevision._userOverrodeUnitPrice(lineItem, item, invoiceCurrency)).toEqual true

  it '_convertLineItemsPrice() method should return true if orginial unit price has been overrode', ->
    # Setup
    store.adapterForType(Vosae.Currency).load store, Vosae.Currency,
      id: 1
      symbol: "EUR"
      rates: [
        {currency_to: "EUR", rate: "1.00"}
        {currency_to: "USD", rate: "2.00"}
      ]
    store.adapterForType(Vosae.Currency).load store, Vosae.Currency,
      id: 2
      symbol: "USD"
      rates: [
        {currency_to: "EUR", rate: "0.50"}
        {currency_to: "USD", rate: "1.00"}
      ]
    store.adapterForType(Vosae.Item).load store, Vosae.Item, {id:1, unit_price: 10, currency: "/api/v1/currency/1/"}
    store.adapterForType(Vosae.Item).load store, Vosae.Item, {id:2, unit_price: 8, currency: "/api/v1/currency/1/"}
    store.adapterForType(Vosae.Item).load store, Vosae.Item, {id:3, unit_price: 57, currency: "/api/v1/currency/2/"}
    store.adapterForType(Vosae.InvoiceRevision).load store, Vosae.InvoiceRevision,
      id: 1
      currency: {     
        symbol: "EUR" 
        rates: [
          {currency_to: "EUR", rate: "1.00"}
          {currency_to: "USD", rate: "2.00"}
        ]
      }
      line_items: [
        {item_id: "1", unit_price: 10}
        {item_id: "2", unit_price: 4}
        {item_id: "3", unit_price: 91}
        {item_id: "3", unit_price: 28.50}
      ]
    invoiceRevision = store.find Vosae.InvoiceRevision, 1
    currentCurrency = invoiceRevision.get('currency')
    newCurrency = store.find Vosae.Currency, 2
    invoiceRevision._convertLineItemsPrice(currentCurrency, newCurrency)
    lineItems = invoiceRevision.get('lineItems')

    # Test
    expect(lineItems.objectAt(0).get('unitPrice')).toEqual 20
    expect(lineItems.objectAt(1).get('unitPrice')).toEqual 8
    expect(lineItems.objectAt(2).get('unitPrice')).toEqual 182
    expect(lineItems.objectAt(3).get('unitPrice')).toEqual 57
    expect(invoiceRevision.get('currency.symbol')).toEqual "USD"
    expect(invoiceRevision.get('currency.rates').toArray()).toEqual newCurrency.get('rates').toArray()

    # SEtup
    currentCurrency = invoiceRevision.get('currency')
    newCurrency = store.find Vosae.Currency, 1
    invoiceRevision._convertLineItemsPrice(currentCurrency, newCurrency)
    lineItems = invoiceRevision.get('lineItems')

    # Test
    expect(lineItems.objectAt(0).get('unitPrice')).toEqual 10
    expect(lineItems.objectAt(1).get('unitPrice')).toEqual 4
    expect(lineItems.objectAt(2).get('unitPrice')).toEqual 91
    expect(lineItems.objectAt(3).get('unitPrice')).toEqual 28.50
    expect(invoiceRevision.get('currency.symbol')).toEqual "EUR"
    expect(invoiceRevision.get('currency.rates').toArray()).toEqual newCurrency.get('rates').toArray()

  it 'updateWithCurrency() method should update the invoiceRevision with the new currency', ->
    # Setup
    store.adapterForType(Vosae.Currency).load store, Vosae.Currency,
      id: 1
      symbol: "EUR"
      rates: [
        {currency_to: "EUR", rate: "1.00"}
        {currency_to: "USD", rate: "2.00"}
      ]
    store.adapterForType(Vosae.Currency).load store, Vosae.Currency,
      id: 2
      symbol: "USD"
      rates: [
        {currency_to: "EUR", rate: "0.50"}
        {currency_to: "USD", rate: "1.00"}
      ]
    store.adapterForType(Vosae.Item).load store, Vosae.Item, {id:1, unit_price: 10, currency: "/api/v1/currency/1/"}
    store.adapterForType(Vosae.Item).load store, Vosae.Item, {id:2, unit_price: 57, currency: "/api/v1/currency/2/"}
    item1 = store.find Vosae.Item, 1
    item2 = store.find Vosae.Item, 2
    store.adapterForType(Vosae.InvoiceRevision).load store, Vosae.InvoiceRevision,
      id: 1
      currency: {     
        symbol: "EUR" 
        rates: [
          {currency_to: "EUR", rate: "1.00"}
          {currency_to: "USD", rate: "2.00"}
        ]
      }
      line_items: [
        {item_id: "1", unit_price: 10}
        {item_id: "2", unit_price: 91}
      ]
    invoiceRevision = store.find Vosae.InvoiceRevision, 1
    newCurrency = store.find Vosae.Currency, 2
    invoiceRevision.updateWithCurrency(newCurrency)

    # The waitFor hook is needed because of the store.findMany() in updateWithCurrency()
    waitsFor ->
      return invoiceRevision.get('currency.symbol') is "USD" # At this point we know updateWithCurrency() is done
    , "", 750

    runs ->
      # Setup
      lineItems = invoiceRevision.get('lineItems')  
      
      # Test
      expect(lineItems.objectAt(0).get('unitPrice')).toEqual 20
      expect(lineItems.objectAt(1).get('unitPrice')).toEqual 182
      expect(invoiceRevision.get('currency.rates').toArray()).toEqual newCurrency.get('rates').toArray()
    
      # Setup
      invoiceRevision.set 'lineItems.content', []
      newCurrency = store.find Vosae.Currency, 1
      invoiceRevision.updateWithCurrency(newCurrency)

      # Test
      expect(invoiceRevision.get('currency.symbol')).toEqual "EUR"
      expect(invoiceRevision.get('currency.rates').toArray()).toEqual newCurrency.get('rates').toArray()

    



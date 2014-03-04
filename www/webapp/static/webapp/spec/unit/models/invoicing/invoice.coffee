store = null

describe 'Vosae.Invoice', ->
  hashInvoice =
    account_type: null
    amount: null
    attachments: []
    balance: null
    current_revision: null
    has_temporary_reference: true
    notes: []
    paid: null
    payments: []
    reference: null
    state: null
    total: null

  expectedPostData =
    "state":null
    "paid":null
    "balance":null
    "has_temporary_reference":true
    "reference":null
    "account_type":"RECEIVABLE"
    "total":null
    "amount":null
    "payments":[]
    "notes":[]
    "attachments":[]
    "current_revision":
      "invoicing_date":"2013-07-26"
      "custom_payment_conditions":null
      "revision":null
      "state":null
      "sender":"Tom Dale"
      "customer_reference":null
      "taxes_application":null
      "line_items":[ 
        "reference":"Siteweb"
        "description":"My site web"
        "item_id":"1"
        "quantity":1
        "unit_price":100
        "tax":"/api/v1/tax/1/"
        "optional": false
      ]
      "pdf":null
      "organization":"/api/v1/organization/1/"
      "contact":"/api/v1/contact/1/"
      "sender_address":
        "type": "WORK"
        "postoffice_box": "a"
        "street_address": "b" 
        "extended_address": "c" 
        "postal_code": "d" 
        "city": "e" 
        "state": "f"
        "country": "g"
      "billing_address":
        "type": "WORK"
        "postoffice_box": "aa"
        "street_address": "bb" 
        "extended_address": "cc" 
        "postal_code": "dd" 
        "city": "ee" 
        "state": "ff"
        "country": "gg"
      "delivery_address":
        "type": "WORK"
        "postoffice_box": "aa"
        "street_address": "bb" 
        "extended_address": "cc" 
        "postal_code": "dd" 
        "city": "ee" 
        "state": "ff"
        "country": "gg"
      "currency":
        "symbol":"EUR"
        "resource_uri":null
        "rates":[
          "currency_to":"GBP"
          "rate":0.86
        ,
          "currency_to":"USD"
          "rate":1.33
        ]

  beforeEach ->
    comp = getAdapterForTest(Vosae.Invoice)
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

  it 'finding all invoice makes a GET to /invoice/', ->
    # Setup
    invoices = store.find Vosae.Invoice
    
    # Test
    enabledFlags invoices, ['isLoaded', 'isValid'], recordArrayFlags
    expectAjaxURL "/invoice/"
    expectAjaxType "GET"

    # Setup
    ajaxHash.success(
      meta: {}
      objects: [$.extend({}, hashInvoice, {id: 1})]
    )
    invoice = invoices.objectAt(0)

    # Test
    statesEqual invoices, 'loaded.saved'
    stateEquals invoice, 'loaded.saved'
    enabledFlagsForArray invoices, ['isLoaded', 'isValid']
    enabledFlags invoice, ['isLoaded', 'isValid']
    expect(invoice).toEqual store.find(Vosae.Invoice, 1)

  it 'finding a invoice by ID makes a GET to /invoice/:id/', ->
    # Setup
    invoice = store.find Vosae.Invoice, 1

    # Test
    stateEquals invoice, 'loading'
    enabledFlags invoice, ['isLoading', 'isValid']
    expectAjaxType "GET"
    expectAjaxURL "/invoice/1/"

    # Setup
    ajaxHash.success($.extend {}, hashInvoice,
      id: 1
      resource_uri: "/api/v1/invoice/1/"
    )

    # Test
    stateEquals invoice, 'loaded.saved'
    enabledFlags invoice, ['isLoaded', 'isValid']
    expect(invoice).toEqual store.find(Vosae.Invoice, 1)

  it 'finding invoices by query makes a GET to /invoice/:query/', ->
    # Setup
    invoices = store.find Vosae.Invoice, {state: "DRAFT"}

    # Test
    expect(invoices.get('length')).toEqual 0
    enabledFlags invoices, ['isLoading'], recordArrayFlags
    expectAjaxURL "/invoice/"
    expectAjaxType "GET"
    expectAjaxData({state: "DRAFT"})

    # Setup
    ajaxHash.success(
      meta: {}
      objects: [
        $.extend {}, hashInvoice, {id: 1, state: "DRAFT"}
        $.extend {}, hashInvoice, {id: 2, state: "DRAFT"}
      ]
    )
    invoice1 = invoices.objectAt 0
    invoice2 = invoices.objectAt 1

    # Test
    statesEqual [invoice1, invoice2], 'loaded.saved'
    enabledFlags invoices, ['isLoaded'], recordArrayFlags
    enabledFlagsForArray [invoice1, invoice2], ['isLoaded'], recordArrayFlags
    expect(invoices.get('length')).toEqual 2
    expect(invoice1.get('state')).toEqual "DRAFT"
    expect(invoice2.get('state')).toEqual "DRAFT"
    expect(invoice1.get('id')).toEqual "1"
    expect(invoice2.get('id')).toEqual "2"

  it 'creating a invoice makes a POST to /invoice/', ->
    # Setup
    store.adapterForType(Vosae.Tax).load store, Vosae.Tax, {id: 1}
    store.adapterForType(Vosae.Organization).load store, Vosae.Organization, {id: 1, }
    store.adapterForType(Vosae.Contact).load store, Vosae.Contact, {id: 1}
    tax = store.find Vosae.Tax, 1
    contact = store.find Vosae.Contact, 1
    organization = store.find Vosae.Organization, 1

    unusedTransaction = store.transaction()
    currentRevision = unusedTransaction.createRecord Vosae.InvoiceRevision
    currency = unusedTransaction.createRecord Vosae.Currency
    billingAddress = unusedTransaction.createRecord Vosae.Address
    deliveryAddress = unusedTransaction.createRecord Vosae.Address
    senderAddress = unusedTransaction.createRecord Vosae.Address
    
    # Setup Currency
    rate1 = unusedTransaction.createRecord Vosae.ExchangeRate
    rate2 = unusedTransaction.createRecord Vosae.ExchangeRate
    rate1.setProperties
      "currencyTo": "GBP"
      "rate": 0.86
    rate2.setProperties
      "currencyTo": "USD"
      "rate": 1.33
    currency.get('rates').addObject rate1
    currency.get('rates').addObject rate2
    currency.setProperties
      "symbol": "EUR"

    # Setup addresses
    senderAddress.setProperties
      "postofficeBox": "a"
      "streetAddress": "b" 
      "extendedAddress": "c" 
      "postalCode": "d" 
      "city": "e" 
      "state": "f"
      "country": "g"

    billingAddress.setProperties
      "postofficeBox": "aa"
      "streetAddress": "bb" 
      "extendedAddress": "cc" 
      "postalCode": "dd" 
      "city": "ee" 
      "state": "ff"
      "country": "gg"
    
    # Setup lineItem
    lineItem = currentRevision.get('lineItems').createRecord()
    lineItem.setProperties
      "ref":"Siteweb"
      "description":"My site web"
      "itemId":"1"
      "quantity":1
      "unitPrice":100
      "tax": tax

    # Setup currentRevision
    currentRevision.setProperties
      'invoicingDate': new Date(2013, 6, 26)
      'sender': "Tom Dale"
      'currency': currency
      'organization': organization
      'contact': contact
      'billingAddress': billingAddress
      'deliveryAddress': deliveryAddress
      'senderAddress': senderAddress

    invoice = store.createRecord Vosae.Invoice, {}
    invoice.setProperties
      "accountType": "RECEIVABLE"
      "currentRevision": currentRevision

    # Test
    stateEquals invoice, 'loaded.created.uncommitted'
    enabledFlags invoice, ['isLoaded', 'isDirty', 'isNew', 'isValid']

    # Setup
    invoice.get('transaction').commit()

    # Test
    stateEquals invoice, 'loaded.created.inFlight'
    enabledFlags invoice, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']
    expectAjaxURL "/invoice/"
    expectAjaxType "POST"
    expectAjaxData(expectedPostData)

    # Setup
    ajaxHash.success($.extend {}, expectedPostData,
      id: 1
      state: "DRAFT"
      resource_uri: "/api/v1/invoice/1/"
    )

    # Test
    stateEquals invoice, 'loaded.saved'
    enabledFlags invoice, ['isLoaded', 'isValid']
    expect(invoice).toEqual store.find(Vosae.Invoice, 1)

  it 'updating a invoice makes a PUT to /invoice/:id/', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, $.extend({}, expectedPostData,
      id: 1
      state: "DRAFT"
    )

    invoice = store.find Vosae.Invoice, 1

    # Test
    stateEquals invoice, 'loaded.saved' 
    enabledFlags invoice, ['isLoaded', 'isValid']

    # Setup
    invoice.setProperties {state:"REGISTERED"}

    # Test
    stateEquals invoice, 'loaded.updated.uncommitted'
    enabledFlags invoice, ['isLoaded', 'isDirty', 'isValid']

    # Setup
    invoice.get('transaction').commit()

    # Test
    stateEquals invoice, 'loaded.updated.inFlight'
    enabledFlags invoice, ['isLoaded', 'isDirty', 'isSaving', 'isValid']
    expectAjaxURL "/invoice/1/"
    expectAjaxType "PUT"
    expectAjaxData($.extend({}, expectedPostData,
      state: "REGISTERED"
    ))

    # Setup
    ajaxHash.success($.extend({}, expectedPostData,
      id: 1
      state: "REGISTERED"
    ))

    # Test
    stateEquals invoice, 'loaded.saved'
    enabledFlags invoice, ['isLoaded', 'isValid']
    expect(invoice).toEqual store.find(Vosae.Invoice, 1)
    expect(invoice.get('state')).toEqual 'REGISTERED'

  it 'deleting an invoice makes a DELETE to /invoice/:id/', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1, state: "DRAFT"}
    invoice = store.find Vosae.Invoice, 1

    # Test
    stateEquals invoice, 'loaded.saved' 
    enabledFlags invoice, ['isLoaded', 'isValid']

    # Setup
    invoice.deleteRecord()

    # Test
    stateEquals invoice, 'deleted.uncommitted'
    enabledFlags invoice, ['isLoaded', 'isDirty', 'isDeleted', 'isValid']

    # Setup
    invoice.get('transaction').commit()

    # Test
    stateEquals invoice, 'deleted.inFlight'
    enabledFlags invoice, ['isLoaded', 'isDirty', 'isSaving', 'isDeleted', 'isValid']
    expectAjaxURL "/invoice/1/"
    expectAjaxType "DELETE"

    # Setup
    ajaxHash.success()

    # Test
    stateEquals invoice, 'deleted.saved'
    enabledFlags invoice, ['isLoaded', 'isDeleted', 'isValid']

  it 'notes hasMany relationship', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice,
      id: 1
      notes: [
       {note: "My note"} 
      ]
    invoice = store.find Vosae.Invoice, 1

    # Test
    expect(invoice.get('notes.firstObject.note')).toEqual "My note"

  it 'can add note', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    invoice = store.find Vosae.Invoice, 1
    note = invoice.get('notes').createRecord()
    note2 = invoice.get('notes').createRecord() 

    # Test
    expect(invoice.get('notes.length')).toEqual 2
    expect(invoice.get('notes').objectAt(0)).toEqual note
    expect(invoice.get('notes').objectAt(1)).toEqual note2

  it 'can delete note', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    invoice = store.find Vosae.Invoice, 1
    note = invoice.get('notes').createRecord()
    note2 = invoice.get('notes').createRecord()

    # Test
    expect(invoice.get('notes.length')).toEqual 2

    # Setup
    invoice.get('notes').removeObject note
    invoice.get('notes').removeObject note2

    # Test
    expect(invoice.get('notes.length')).toEqual 0

  it 'attachments hasMany relationship', ->
    # Setup
    store.adapterForType(Vosae.File).load store, Vosae.File, {id: 1}
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice,
      id: 1
      attachments: [
       "/api/v1/file/1/"
      ]
    file = store.find Vosae.File, 1
    invoice = store.find Vosae.Invoice, 1

    # Test
    expect(invoice.get('attachments.firstObject')).toEqual file

  it 'can add attachment', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    invoice = store.find Vosae.Invoice, 1
    attachment = invoice.get('attachments').createRecord()
    attachment2 = invoice.get('attachments').createRecord()   

    # Test
    expect(invoice.get('attachments.length')).toEqual 2
    expect(invoice.get('attachments').objectAt(0)).toEqual attachment
    expect(invoice.get('attachments').objectAt(1)).toEqual attachment2

  it 'can delete attachment', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    invoice = store.find Vosae.Invoice, 1
    attachment = invoice.get('attachments').createRecord()
    attachment2 = invoice.get('attachments').createRecord()

    # Test
    expect(invoice.get('attachments.length')).toEqual 2

    # Setup
    invoice.get('attachments').removeObject attachment
    invoice.get('attachments').removeObject attachment2

    # Test
    expect(invoice.get('attachments.length')).toEqual 0

  it 'payments hasMany relationship', ->
    # Setup
    store.adapterForType(Vosae.Payment).load store, Vosae.Payment, {id: 1}
    payment = store.find Vosae.Payment, 1
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice,
      id: 1
      payments: ["/api/v1/payment/1/"]
    invoice = store.find Vosae.Invoice, 1

    # Test
    expect(invoice.get('payments.firstObject')).toEqual payment

  it 'can add payment', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    invoice = store.find Vosae.Invoice, 1
    payment = invoice.get('payments').createRecord()
    payment2 = invoice.get('payments').createRecord()   

    # Test
    expect(invoice.get('payments.length')).toEqual 2
    expect(invoice.get('payments').objectAt(0)).toEqual payment
    expect(invoice.get('payments').objectAt(1)).toEqual payment2

  it 'can delete payment', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    invoice = store.find Vosae.Invoice, 1
    payment = invoice.get('payments').createRecord()
    payment2 = invoice.get('payments').createRecord()

    # Test
    expect(invoice.get('payments.length')).toEqual 2

    # Setup
    invoice.get('payments').removeObject payment
    invoice.get('payments').removeObject payment2

    # Test
    expect(invoice.get('payments.length')).toEqual 0

  it 'issuer belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.User).load store, Vosae.User, {id: 1}
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1, issuer: "/api/v1/user/1/"}
    issuer = store.find Vosae.User, 1
    invoice = store.find Vosae.Invoice, 1

    # Test
    expect(invoice.get('issuer')).toEqual issuer

  it 'organization belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.Organization).load store, Vosae.Organization, {id: 1}
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1, organization: "/api/v1/organization/1/"}
    organization = store.find Vosae.Organization, 1
    invoice = store.find Vosae.Invoice, 1

    # Test
    expect(invoice.get('organization')).toEqual organization

  it 'contact belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.Contact).load store, Vosae.Contact, {id: 1}
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1, contact: "/api/v1/contact/1/"}
    contact = store.find Vosae.Contact, 1
    invoice = store.find Vosae.Invoice, 1

    # Test
    expect(invoice.get('contact')).toEqual contact

  it 'invoiceRevision belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1, current_revision: {state: "DRAFT"}}
    invoice = store.find Vosae.Invoice, 1

    # Test
    expect(invoice.get('currentRevision.state')).toEqual "DRAFT"

  it 'relatedQuotation belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.Quotation).load store, Vosae.Quotation, {id: 1}
    quotation = store.find Vosae.Quotation, 1
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1, related_quotation: "/api/v1/quotation/1/"}
    invoice = store.find Vosae.Invoice, 1

    # Test
    expect(invoice.get('relatedQuotation')).toEqual quotation

  it 'relatedPurchaseOrder belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.PurchaseOrder).load store, Vosae.PurchaseOrder, {id: 1}
    purchaseOrder = store.find Vosae.PurchaseOrder, 1
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1, related_purchase_order: "/api/v1/purchaseOrder/1/"}
    invoice = store.find Vosae.Invoice, 1

    # Test
    expect(invoice.get('relatedPurchaseOrder')).toEqual purchaseOrder

  it 'isUpdatingState property should be false by default', ->
    # Setup
    invoice = store.createRecord Vosae.Invoice, {}

    # Test
    expect(invoice.get('isUpdatingState')).toEqual false

  it 'isGeneratingPdfState property should be false by default', ->
    # Setup
    invoice = store.createRecord Vosae.Invoice, {}

    # Test
    expect(invoice.get('isGeneratingPdfState')).toEqual false

  it 'relatedColor property should return success', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    invoice = store.find Vosae.Invoice, 1

    # Test
    expect(invoice.get('relatedColor')).toEqual "success"

  it 'isInvoice property should return false', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    invoice = store.find Vosae.Invoice, 1

    # Test
    expect(invoice.get('isInvoice')).toBeTruthy()

  it 'isQuotation property should return false', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    invoice = store.find Vosae.Invoice, 1

    # Test
    expect(invoice.get('isQuotation')).toBeFalsy()

  it 'isCreditNote property should return true', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    invoice = store.find Vosae.Invoice, 1

    # Test
    expect(invoice.get('isCreditNote')).toBeFalsy()

  it 'isPurchaseOrder property should return true', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    invoice = store.find Vosae.Invoice, 1

    # Test
    expect(invoice.get('isPurchaseOrder')).toBeFalsy()

  it 'displayState property should return the acutal state formated', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    invoice = store.find Vosae.Invoice, 1
    
    # Test
    Vosae.Config.invoiceStatesChoices.forEach (state) ->
      invoice.set('state', state.get('value'))
      expect(invoice.get('displayState')).toBeTruthy()

  it 'canAddPayment property should return true if payment could be added to the invoice', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1, state:"REGISTERED"}
    invoice = store.find Vosae.Invoice, 1
    
    # Test
    expect(invoice.get('canAddPayment')).toEqual false

    # Setup
    invoice.set 'balance', 0

    # Test
    expect(invoice.get('canAddPayment')).toEqual false

    # Setup
    invoice.set 'balance', 1000

    # Test
    expect(invoice.get('canAddPayment')).toEqual true

    # Setup
    payment = invoice.get('payments').createRecord()

    # Test
    expect(invoice.get('canAddPayment')).toEqual false

  it 'isPayableOrPaid property return true if invoice is payable or paid', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    invoice = store.find Vosae.Invoice, 1

    # Test
    expect(invoice.get('isPayableOrPaid')).toEqual false
    Vosae.Config.invoiceStatesChoices.forEach (state) ->
      invoice.set('state', state.get('value'))
      if ["REGISTERED", "OVERDUE", "PART_PAID", "PAID"].contains state.get('value')
        expect(invoice.get('isPayableOrPaid')).toBeTruthy()
      else
        expect(invoice.get('isPayableOrPaid')).toBeFalsy()

  it 'availableStates return an array with the available states based on the current state', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    invoice = store.find Vosae.Invoice, 1
    availableStates = invoice.get('availableStates')

    # Test
    expect(availableStates).toEqual []

    # Setup
    invoice.set "state", "DRAFT"
    availableStates = invoice.get('availableStates')

    # Test
    expect(availableStates.get('length')).toEqual 1
    expect(availableStates.getEach('value')).toContain "REGISTERED"

    # Setup
    invoice.set "state", "REGISTERED"
    availableStates = invoice.get('availableStates')

    # Test
    expect(availableStates.get('length')).toEqual 1
    expect(availableStates.getEach('value')).toContain "CANCELLED"

    # Setup
    invoice.set "state", "OVERDUE"
    availableStates = invoice.get('availableStates')

    # Test
    expect(availableStates.get('length')).toEqual 1
    expect(availableStates.getEach('value')).toContain "CANCELLED"

    # Setup
    invoice.set "state", "PART_PAID"
    availableStates = invoice.get('availableStates')

    # Test
    expect(availableStates.get('length')).toEqual 1
    expect(availableStates.getEach('value')).toContain "CANCELLED"

    # Setup
    invoice.set "state", "PAID"
    availableStates = invoice.get('availableStates')

    # Test
    expect(availableStates.get('length')).toEqual 1
    expect(availableStates.getEach('value')).toContain "CANCELLED"

  it 'isModifiable property return true if invoice can be edited', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    invoice = store.find Vosae.Invoice, 1

    # Test
    expect(invoice.get('isModifiable')).toBeFalsy()
    Vosae.Config.invoiceStatesChoices.forEach (state) ->
      invoice.set('state', state.get('value'))
      if state.get('value') is 'DRAFT'
        expect(invoice.get('isModifiable')).toBeTruthy()
      else
        expect(invoice.get('isModifiable')).toBeFalsy()

  it 'isDeletable property return true if invoice can be deleted', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    invoice = store.find Vosae.Invoice, 1

    # Test
    expect(invoice.get('isModifiable')).toBeFalsy()
    expect(invoice.get('isDeletable')).toBeFalsy()

    # Setup
    invoice.set('state', 'DRAFT')

    # Test
    expect(invoice.get('isModifiable')).toBeTruthy()
    expect(invoice.get('isDeletable')).toBeTruthy()

  it 'isCancelable property return true if invoice is in a cancelable state', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    invoice = store.find Vosae.Invoice, 1

    # Test
    expect(invoice.get('isCancelable')).toBeFalsy()
    Vosae.Config.invoiceStatesChoices.forEach (state) ->
      invoice.set('state', state.get('value'))
      if ["REGISTERED", "OVERDUE", "PART_PAID", "PAID"].contains state.get('value')
        expect(invoice.get('isCancelable')).toBeTruthy()
      else
        expect(invoice.get('isCancelable')).toBeFalsy()

  it 'isPayable property return true if invoice is in a payable state', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    invoice = store.find Vosae.Invoice, 1

    # Test
    expect(invoice.get('isPayable')).toBeFalsy()
    Vosae.Config.invoiceStatesChoices.forEach (state) ->
      invoice.set('state', state.get('value'))
      if ["REGISTERED", "OVERDUE", "PART_PAID"].contains state.get('value')
        expect(invoice.get('isPayable')).toBeTruthy()
      else
        expect(invoice.get('isPayable')).toBeFalsy()

  it 'isPaid property return true if invoice is paid', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    invoice = store.find Vosae.Invoice, 1

    # Test
    expect(invoice.get('isPaid')).toBeFalsy()
    Vosae.Config.invoiceStatesChoices.forEach (state) ->
      invoice.set('state', state.get('value'))
      if state.get('value') is 'PAID'
        expect(invoice.get('isPaid')).toBeTruthy()
      else
        expect(invoice.get('isPaid')).toBeFalsy()

  it 'isDraft property return true if invoice is draft', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    invoice = store.find Vosae.Invoice, 1

    # Test
    expect(invoice.get('isDraft')).toBeFalsy()
    Vosae.Config.invoiceStatesChoices.forEach (state) ->
      invoice.set('state', state.get('value'))
      if state.get('value') is 'DRAFT'
        expect(invoice.get('isDraft')).toBeTruthy()
      else
        expect(invoice.get('isDraft')).toBeFalsy()

  it 'isCancelled property return true if invoice has been cancelled', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    invoice = store.find Vosae.Invoice, 1

    # Test
    expect(invoice.get('isCancelled')).toBeFalsy()
    Vosae.Config.invoiceStatesChoices.forEach (state) ->
      invoice.set('state', state.get('value'))
      if state.get('value') is 'CANCELLED'
        expect(invoice.get('isCancelled')).toBeTruthy()
      else
        expect(invoice.get('isCancelled')).toBeFalsy()

  it 'isInvoicable property return true if invoice is invoicable', ->
    # Setup
    store.adapterForType(Vosae.Contact).load store, Vosae.Contact, {id: 1}
    store.adapterForType(Vosae.Organization).load store, Vosae.Organization, {id: 1}
    store.adapterForType(Vosae.InvoiceRevision).load store, Vosae.InvoiceRevision, {id: 1}
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    invoice = store.find Vosae.Invoice, 1
    invoice.setProperties
      'state': 'DRAFT'
      'contact': store.find(Vosae.Contact, 1)
      'organization': store.find(Vosae.Organization, 1)
      'currentRevision': store.find(Vosae.InvoiceRevision, 1)
      'currentRevision.invoicingDate': (new Date())
      'currentRevision.dueDate': (new Date())
      'currentRevision.customPaymentConditions': 'CASH'
    invoice.get('currentRevision.lineItems').createRecord()

    # Test
    expect(invoice.get('isInvoicable')).toBeTruthy()

    # Setup
    invoice.set 'state', 'REGISTERED'

    # Test
    expect(invoice.get('isInvoicable')).toBeFalsy()

    # Setup
    invoice.set 'state', 'DRAFT'
    invoice.set 'contact', null

    # Test
    expect(invoice.get('isInvoicable')).toBeTruthy()

    # Setup
    invoice.set 'organization', null

    # Test
    expect(invoice.get('isInvoicable')).toBeFalsy()

    # Setup
    invoice.set 'contact', store.find(Vosae.Contact, 1)
    invoice.set 'organization', store.find(Vosae.Organization, 1)
    invoice.set 'currentRevision.invoicingDate', null

    # Test
    expect(invoice.get('isInvoicable')).toBeFalsy()

    # Setup
    invoice.set 'currentRevision.invoicingDate', (new Date())

    # Test
    expect(invoice.get('isInvoicable')).toBeTruthy()

    # Setup
    invoice.set 'currentRevision.dueDate', null

    # Test
    expect(invoice.get('isInvoicable')).toBeTruthy()

    # Setup
    invoice.set 'currentRevision.customPaymentConditions', null

    # Test
    expect(invoice.get('isInvoicable')).toBeFalsy()

    # Setup
    invoice.set 'currentRevision.dueDate', (new Date())
    invoice.set 'currentRevision.customPaymentConditions', 'CASH'

    # Test
    expect(invoice.get('isInvoicable')).toBeTruthy()

    # Setup
    invoice.get('currentRevision.lineItems').removeObject invoice.get('currentRevision.lineItems').objectAt(0)

    # Test
    expect(invoice.get('isInvoicable')).toBeFalsy()

  it 'invoiceCancel() method should cancel the Invoice', ->
    # Setup
    store.adapterForType(Vosae.CreditNote).load store, Vosae.CreditNote, {id: 1}
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1, state: 'REGISTERED'}
    invoice = store.find Vosae.Invoice, 1
    controller = Vosae.lookup("controller:invoice.edit")
    controller.transitionToRoute = ->
      return
    invoice.invoiceCancel(controller)

    # Test
    expect(invoice.get('isCancelling')).toEqual true
    expectAjaxURL "/invoice/1/cancel/"
    expectAjaxType "PUT"

    # Setup
    ajaxHash.success({credit_note_uri: "/api/v1/credit_note/1/"})

    # Test
    expectAjaxType "GET"
    expectAjaxURL "/invoice/1/"

    # Setup
    ajaxHash.success {state: "CANCELLED"}

    # Test
    expect(invoice.get('isCancelling')).toEqual false
store = null

describe 'Vosae.Quotation', ->
  hashQuotation =
    account_type: null
    amount: null
    attachments: []
    current_revision: null
    notes: []
    reference: null
    state: null
    total: null

  expectedPostData =
    "state":null
    "reference":null
    "account_type":"RECEIVABLE"
    "total":null
    "amount":null
    "notes":[]
    "attachments":[]
    "current_revision":
      "quotation_date":"2013-07-26"
      "quotation_validity":"2013-07-28"
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
    comp = getAdapterForTest(Vosae.Quotation)
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

  it 'finding all quotation makes a GET to /quotation/', ->
    # Setup
    quotations = store.find Vosae.Quotation
    
    # Test
    enabledFlags quotations, ['isLoaded', 'isValid'], recordArrayFlags
    expectAjaxURL "/quotation/"
    expectAjaxType "GET"

    # Setup
    ajaxHash.success(
      meta: {}
      objects: [$.extend({}, hashQuotation, {id: 1})]
    )
    quotation = quotations.objectAt(0)

    # Test
    statesEqual quotations, 'loaded.saved'
    stateEquals quotation, 'loaded.saved'
    enabledFlagsForArray quotations, ['isLoaded', 'isValid']
    enabledFlags quotation, ['isLoaded', 'isValid']
    expect(quotation).toEqual store.find(Vosae.Quotation, 1)

  it 'finding a quotation by ID makes a GET to /quotation/:id/', ->
    # Setup
    quotation = store.find Vosae.Quotation, 1

    # Test
    stateEquals quotation, 'loading'
    enabledFlags quotation, ['isLoading', 'isValid']
    expectAjaxType "GET"
    expectAjaxURL "/quotation/1/"

    # Setup
    ajaxHash.success($.extend {}, hashQuotation,
      id: 1
      resource_uri: "/api/v1/quotation/1/"
    )

    # Test
    stateEquals quotation, 'loaded.saved'
    enabledFlags quotation, ['isLoaded', 'isValid']
    expect(quotation).toEqual store.find(Vosae.Quotation, 1)

  it 'finding quotations by query makes a GET to /quotation/:query/', ->
    # Setup
    quotations = store.find Vosae.Quotation, {state: "DRAFT"}

    # Test
    expect(quotations.get('length')).toEqual 0
    enabledFlags quotations, ['isLoading'], recordArrayFlags
    expectAjaxURL "/quotation/"
    expectAjaxType "GET"
    expectAjaxData({state: "DRAFT"})

    # Setup
    ajaxHash.success(
      meta: {}
      objects: [
        $.extend {}, hashQuotation, {id: 1, state: "DRAFT"}
        $.extend {}, hashQuotation, {id: 2, state: "DRAFT"}
      ]
    )
    quotation1 = quotations.objectAt 0
    quotation2 = quotations.objectAt 1

    # Test
    statesEqual [quotation1, quotation2], 'loaded.saved'
    enabledFlags quotations, ['isLoaded'], recordArrayFlags
    enabledFlagsForArray [quotation1, quotation2], ['isLoaded'], recordArrayFlags
    expect(quotations.get('length')).toEqual 2
    expect(quotation1.get('state')).toEqual "DRAFT"
    expect(quotation2.get('state')).toEqual "DRAFT"
    expect(quotation1.get('id')).toEqual "1"
    expect(quotation2.get('id')).toEqual "2"

  it 'creating a quotation makes a POST to /quotation/', ->
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
      'quotationDate': new Date(2013, 6, 26)
      'quotationValidity': new Date(2013, 6, 28)
      'sender': "Tom Dale"
      'currency': currency
      'organization': organization
      'contact': contact
      'billingAddress': billingAddress
      'deliveryAddress': deliveryAddress
      'senderAddress': senderAddress

    quotation = store.createRecord Vosae.Quotation, {}
    quotation.setProperties
      "accountType": "RECEIVABLE"
      "currentRevision": currentRevision

    # Test
    stateEquals quotation, 'loaded.created.uncommitted'
    enabledFlags quotation, ['isLoaded', 'isDirty', 'isNew', 'isValid']

    # Setup
    quotation.get('transaction').commit()

    # Test
    stateEquals quotation, 'loaded.created.inFlight'
    enabledFlags quotation, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']
    expectAjaxURL "/quotation/"
    expectAjaxType "POST"
    expectAjaxData(expectedPostData)

    # Setup
    ajaxHash.success($.extend {}, expectedPostData,
      id: 1
      state: "DRAFT"
      resource_uri: "/api/v1/quotation/1/"
    )

    # Test
    stateEquals quotation, 'loaded.saved'
    enabledFlags quotation, ['isLoaded', 'isValid']
    expect(quotation).toEqual store.find(Vosae.Quotation, 1)

  it 'updating a quotation makes a PUT to /quotation/:id/', ->
    # Setup
    store.adapterForType(Vosae.Quotation).load store, Vosae.Quotation, $.extend({}, expectedPostData,
      id: 1
      state: "DRAFT"
    )

    quotation = store.find Vosae.Quotation, 1

    # Test
    stateEquals quotation, 'loaded.saved' 
    enabledFlags quotation, ['isLoaded', 'isValid']

    # Setup
    quotation.setProperties {state:"REGISTERED"}

    # Test
    stateEquals quotation, 'loaded.updated.uncommitted'
    enabledFlags quotation, ['isLoaded', 'isDirty', 'isValid']

    # Setup
    quotation.get('transaction').commit()

    # Test
    stateEquals quotation, 'loaded.updated.inFlight'
    enabledFlags quotation, ['isLoaded', 'isDirty', 'isSaving', 'isValid']
    expectAjaxURL "/quotation/1/"
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
    stateEquals quotation, 'loaded.saved'
    enabledFlags quotation, ['isLoaded', 'isValid']
    expect(quotation).toEqual store.find(Vosae.Quotation, 1)
    expect(quotation.get('state')).toEqual 'REGISTERED'

  it 'deleting a quotation makes a DELETE to /quotation/:id/', ->
    # Setup
    store.adapterForType(Vosae.Quotation).load store, Vosae.Quotation, {id: 1, state: "DRAFT"}
    quotation = store.find Vosae.Quotation, 1

    # Test
    stateEquals quotation, 'loaded.saved' 
    enabledFlags quotation, ['isLoaded', 'isValid']

    # Setup
    quotation.deleteRecord()

    # Test
    stateEquals quotation, 'deleted.uncommitted'
    enabledFlags quotation, ['isLoaded', 'isDirty', 'isDeleted', 'isValid']

    # Setup
    quotation.get('transaction').commit()

    # Test
    stateEquals quotation, 'deleted.inFlight'
    enabledFlags quotation, ['isLoaded', 'isDirty', 'isSaving', 'isDeleted', 'isValid']
    expectAjaxURL "/quotation/1/"
    expectAjaxType "DELETE"

    # Setup
    ajaxHash.success()

    # Test
    stateEquals quotation, 'deleted.saved'
    enabledFlags quotation, ['isLoaded', 'isDeleted', 'isValid']

  it 'notes hasMany relationship', ->
    # Setup
    store.adapterForType(Vosae.Quotation).load store, Vosae.Quotation,
      id: 1
      notes: [
       {note: "My note"} 
      ]
    quotation = store.find Vosae.Quotation, 1

    # Test
    expect(quotation.get('notes.firstObject.note')).toEqual "My note"

  it 'can add note', ->
    # Setup
    store.adapterForType(Vosae.Quotation).load store, Vosae.Quotation, {id: 1}
    quotation = store.find Vosae.Quotation, 1
    note = quotation.get('notes').createRecord()
    note2 = quotation.get('notes').createRecord()    

    # Test
    expect(quotation.get('notes.length')).toEqual 2
    expect(quotation.get('notes').objectAt(0)).toEqual note
    expect(quotation.get('notes').objectAt(1)).toEqual note2

  it 'can delete note', ->
    # Setup
    store.adapterForType(Vosae.Quotation).load store, Vosae.Quotation, {id: 1}
    quotation = store.find Vosae.Quotation, 1
    note = quotation.get('notes').createRecord()
    note2 = quotation.get('notes').createRecord()

    # Test
    expect(quotation.get('notes.length')).toEqual 2

    # Setup
    quotation.get('notes').removeObject note
    quotation.get('notes').removeObject note2

    # Test
    expect(quotation.get('notes.length')).toEqual 0

  it 'attachments hasMany relationship', ->
    # Setup
    store.adapterForType(Vosae.File).load store, Vosae.File, {id: 1}
    store.adapterForType(Vosae.Quotation).load store, Vosae.Quotation,
      id: 1
      attachments: [
       "/api/v1/file/1/"
      ]
    file = store.find Vosae.File, 1
    quotation = store.find Vosae.Quotation, 1

    # Test
    expect(quotation.get('attachments.firstObject')).toEqual file

  it 'can add attachment', ->
    # Setup
    store.adapterForType(Vosae.Quotation).load store, Vosae.Quotation, {id: 1}
    quotation = store.find Vosae.Quotation, 1
    attachment = quotation.get('attachments').createRecord()
    attachment2 = quotation.get('attachments').createRecord()   

    # Test
    expect(quotation.get('attachments.length')).toEqual 2
    expect(quotation.get('attachments').objectAt(0)).toEqual attachment
    expect(quotation.get('attachments').objectAt(1)).toEqual attachment2

  it 'can delete attachment', ->
    # Setup
    store.adapterForType(Vosae.Quotation).load store, Vosae.Quotation, {id: 1}
    quotation = store.find Vosae.Quotation, 1
    attachment = quotation.get('attachments').createRecord()
    attachment2 = quotation.get('attachments').createRecord()

    # Test
    expect(quotation.get('attachments.length')).toEqual 2

    # Setup
    quotation.get('attachments').removeObject attachment
    quotation.get('attachments').removeObject attachment2

    # Test
    expect(quotation.get('attachments.length')).toEqual 0

  it 'issuer belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.User).load store, Vosae.User, {id: 1}
    store.adapterForType(Vosae.Quotation).load store, Vosae.Quotation, {id: 1, issuer: "/api/v1/user/1/"}
    issuer = store.find Vosae.User, 1
    quotation = store.find Vosae.Quotation, 1

    # Test
    expect(quotation.get('issuer')).toEqual issuer

  it 'organization belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.Organization).load store, Vosae.Organization, {id: 1}
    store.adapterForType(Vosae.Quotation).load store, Vosae.Quotation, {id: 1, organization: "/api/v1/organization/1/"}
    organization = store.find Vosae.Organization, 1
    quotation = store.find Vosae.Quotation, 1

    # Test
    expect(quotation.get('organization')).toEqual organization

  it 'contact belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.Contact).load store, Vosae.Contact, {id: 1}
    store.adapterForType(Vosae.Quotation).load store, Vosae.Quotation, {id: 1, contact: "/api/v1/contact/1/"}
    contact = store.find Vosae.Contact, 1
    quotation = store.find Vosae.Quotation, 1

    # Test
    expect(quotation.get('contact')).toEqual contact

  it 'invoiceRevision belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.Quotation).load store, Vosae.Quotation, {id: 1, current_revision: {state: "DRAFT"}}
    quotation = store.find Vosae.Quotation, 1

    # Test
    expect(quotation.get('currentRevision.state')).toEqual "DRAFT"

  it 'isUpdatingState property should be false by default', ->
    # Setup
    quotation = store.createRecord Vosae.Quotation, {}

    # Test
    expect(quotation.get('isUpdatingState')).toEqual false

  it 'isGeneratingPdfState property should be false by default', ->
    # Setup
    quotation = store.createRecord Vosae.Quotation, {}

    # Test
    expect(quotation.get('isGeneratingPdfState')).toEqual false

  it 'relatedColor property should return primary', ->
    # Setup
    store.adapterForType(Vosae.Quotation).load store, Vosae.Quotation, {id: 1}
    quotation = store.find Vosae.Quotation, 1

    # Test
    expect(quotation.get('relatedColor')).toEqual "primary"

  it 'isInvoice property should return false', ->
    # Setup
    store.adapterForType(Vosae.Quotation).load store, Vosae.Quotation, {id: 1}
    quotation = store.find Vosae.Quotation, 1

    # Test
    expect(quotation.get('isInvoice')).toBeFalsy()

  it 'isQuotation property should return false', ->
    # Setup
    store.adapterForType(Vosae.Quotation).load store, Vosae.Quotation, {id: 1}
    quotation = store.find Vosae.Quotation, 1

    # Test
    expect(quotation.get('isQuotation')).toBeTruthy()

  it 'isCreditNote property should return true', ->
    # Setup
    store.adapterForType(Vosae.Quotation).load store, Vosae.Quotation, {id: 1}
    quotation = store.find Vosae.Quotation, 1

    # Test
    expect(quotation.get('isCreditNote')).toBeFalsy()

  it 'isPurchaseOrder property should return true', ->
    # Setup
    store.adapterForType(Vosae.Quotation).load store, Vosae.Quotation, {id: 1}
    quotation = store.find Vosae.Quotation, 1

    # Test
    expect(quotation.get('isPurchaseOrder')).toBeFalsy()  

  it 'displayState property should return the acutal state formated', ->
    # Setup
    store.adapterForType(Vosae.Quotation).load store, Vosae.Quotation, {id: 1}
    quotation = store.find Vosae.Quotation, 1
    
    # Test
    Vosae.Config.quotationStatesChoices.forEach (state) ->
      quotation.set('state', state.get('value'))
      expect(quotation.get('displayState')).toBeTruthy()

  it 'availableStates return an array with the available states based on the current state', ->
    # Setup
    store.adapterForType(Vosae.Quotation).load store, Vosae.Quotation, {id: 1}
    quotation = store.find Vosae.Quotation, 1
    availableStates = quotation.get('availableStates')

    # Test
    expect(availableStates).toEqual []

    # Setup
    quotation.set "state", "DRAFT"
    availableStates = quotation.get('availableStates')

    # Test
    expect(availableStates.get('length')).toEqual 3
    expect(availableStates.getEach('label')).toContain "Awaiting approval"
    expect(availableStates.getEach('label')).toContain "Approved"
    expect(availableStates.getEach('label')).toContain "Refused"

    # Setup
    quotation.set "state", "AWAITING_APPROVAL"
    availableStates = quotation.get('availableStates')

    # Test
    expect(availableStates.get('length')).toEqual 2
    expect(availableStates.getEach('label')).toContain "Approved"
    expect(availableStates.getEach('label')).toContain "Refused"

    # Setup
    quotation.set "state", "EXPIRED"
    availableStates = quotation.get('availableStates')

    # Test
    expect(availableStates.get('length')).toEqual 3
    expect(availableStates.getEach('label')).toContain "Awaiting approval"
    expect(availableStates.getEach('label')).toContain "Approved"
    expect(availableStates.getEach('label')).toContain "Refused"

    # Setup
    quotation.set "state", "REFUSED"
    availableStates = quotation.get('availableStates')

    # Test
    expect(availableStates.get('length')).toEqual 2
    expect(availableStates.getEach('label')).toContain "Awaiting approval"
    expect(availableStates.getEach('label')).toContain "Approved"

  it 'isInvoiceable property return true if quotation can be transform to an invoice', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    store.adapterForType(Vosae.Quotation).load store, Vosae.Quotation, {id: 1}
    store.adapterForType(Vosae.InvoiceBaseGroup).load store, Vosae.InvoiceBaseGroup, {id: 1}
    quotation = store.find Vosae.Quotation, 1
    quotation.set "group", store.find(Vosae.InvoiceBaseGroup, 1)

    # Test
    expect(quotation.get('isInvoiceable')).toEqual true

    # Setup
    quotation.set "group.relatedInvoice", store.find(Vosae.Invoice, 1)

    # Test
    expect(quotation.get('isInvoiceable')).toEqual false

  it 'isModifiable property return true if quotation can be edited', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    store.adapterForType(Vosae.Quotation).load store, Vosae.Quotation, {id: 1}
    store.adapterForType(Vosae.InvoiceBaseGroup).load store, Vosae.InvoiceBaseGroup, {id: 1}
    quotation = store.find Vosae.Quotation, 1
    quotation.set "group", store.find(Vosae.InvoiceBaseGroup, 1)

    # Test
    expect(quotation.get('isModifiable')).toEqual true

    # Setup
    quotation.set "group.relatedInvoice", store.find(Vosae.Invoice, 1)

    # Test
    expect(quotation.get('isModifiable')).toEqual false

  it 'isDeletable property return true if quotation can be deleted', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    store.adapterForType(Vosae.Quotation).load store, Vosae.Quotation, {id: 1}
    quotation = store.find Vosae.Quotation, 1
    quotation.set "group", store.find(Vosae.InvoiceBaseGroup, 1)

    # Test
    expect(quotation.get('isDeletable')).toEqual true

    # Setup
    quotation.set "group.relatedInvoice", store.find(Vosae.Invoice, 1)

    # Test
    expect(quotation.get('isDeletable')).toEqual false

    # Setup
    quotation.set "group.relatedInvoice", null
    quotation.get("group.downPaymentInvoices").createRecord()

    # Test
    expect(quotation.get('isDeletable')).toEqual false

    # Setup
    quotation.setProperties
      "group.downPaymentInvoices.content": []
      "id": null

    # Test
    expect(quotation.get('isDeletable')).toEqual false

  it 'isIssuable property return true if quotation could be sent', ->
    # Setup
    store.adapterForType(Vosae.Quotation).load store, Vosae.Quotation, {id: 1}
    quotation = store.find Vosae.Quotation, 1

    # Test
    expect(quotation.get('isIssuable')).toEqual false

    # Setup
    quotation.set "state", "DRAFT"

    # Test
    expect(quotation.get('isIssuable')).toEqual false

    # Setup
    quotation.set "state", "EXPIRED"

    # Test
    expect(quotation.get('isIssuable')).toEqual true

    # Setup
    quotation.set "state", "AWAITING_APPROVAL"

    # Test
    expect(quotation.get('isIssuable')).toEqual true

    # Setup
    quotation.set "state", "REFUSED"

    # Test
    expect(quotation.get('isIssuable')).toEqual true

    # Setup
    quotation.set "state", "APPROVED"

    # Test
    expect(quotation.get('isIssuable')).toEqual true

    # Setup
    quotation.set "state", "INVOICED"

    # Test
    expect(quotation.get('isIssuable')).toEqual true

  it 'isInvoiced property return true if quotation is invoiced', ->
    # Setup
    store.adapterForType(Vosae.Quotation).load store, Vosae.Quotation, {id: 1}
    quotation = store.find Vosae.Quotation, 1

    # Test
    expect(quotation.get('isInvoiced')).toEqual false

    # Setup
    quotation.set "state", "DRAFT"

    # Test
    expect(quotation.get('isInvoiced')).toEqual false

    # Setup
    quotation.set "state", "EXPIRED"

    # Test
    expect(quotation.get('isInvoiced')).toEqual false

    # Setup
    quotation.set "state", "AWAITING_APPROVAL"

    # Test
    expect(quotation.get('isInvoiced')).toEqual false

    # Setup
    quotation.set "state", "REFUSED"

    # Test
    expect(quotation.get('isInvoiced')).toEqual false

    # Setup
    quotation.set "state", "APPROVED"

    # Test
    expect(quotation.get('isInvoiced')).toEqual false

    # Setup
    quotation.set "state", "INVOICED"

    # Test
    expect(quotation.get('isInvoiced')).toEqual true

  it 'makeInvoice() method should make an Invoice based on the quotation', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    store.adapterForType(Vosae.Quotation).load store, Vosae.Quotation, {id: 1}
    quotation = store.find Vosae.Quotation, 1
    controller = Vosae.lookup("controller:quotation.edit")
    controller.transitionToRoute = ->
      return
    quotation.makeInvoice(controller)

    # Test
    expect(quotation.get('isMakingInvoice')).toEqual true
    expectAjaxURL "/quotation/1/make_invoice/"
    expectAjaxType "PUT"

    # Setup
    ajaxHash.success({invoice_uri: "/api/v1/invoice/1/"})

    # Test
    expectAjaxType "GET"
    expectAjaxURL "/quotation/1/"

    # Setup
    ajaxHash.success {state: "INVOICED"}

    # Test
    expect(quotation.get('isMakingInvoice')).toEqual false
store = null

describe 'Vosae.CreditNote', ->
  hashCreditNote =
    account_type: null
    amount: null
    attachments: []
    current_revision: null
    notes: []
    reference: null
    state: null
    total: null

  beforeEach ->
    comp = getAdapterForTest(Vosae.CreditNote)
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

  it 'finding all creditNote makes a GET to /credit_note/', ->
    # Setup
    creditNotes = store.find Vosae.CreditNote
    
    # Test
    enabledFlags creditNotes, ['isLoaded', 'isValid'], recordArrayFlags
    expectAjaxURL "/credit_note/"
    expectAjaxType "GET"

    # Setup
    ajaxHash.success(
      meta: {}
      objects: [$.extend({}, hashCreditNote, {id: 1})]
    )
    creditNote = creditNotes.objectAt(0)

    # Test
    statesEqual creditNotes, 'loaded.saved'
    stateEquals creditNote, 'loaded.saved'
    enabledFlagsForArray creditNotes, ['isLoaded', 'isValid']
    enabledFlags creditNote, ['isLoaded', 'isValid']
    expect(creditNote).toEqual store.find(Vosae.CreditNote, 1)

  it 'finding a creditNote by ID makes a GET to /credit_note/:id/', ->
    # Setup
    creditNote = store.find Vosae.CreditNote, 1

    # Test
    stateEquals creditNote, 'loading'
    enabledFlags creditNote, ['isLoading', 'isValid']
    expectAjaxType "GET"
    expectAjaxURL "/credit_note/1/"

    # Setup
    ajaxHash.success($.extend {}, hashCreditNote,
      id: 1
      resource_uri: "/api/v1/credit_note/1/"
    )

    # Test
    stateEquals creditNote, 'loaded.saved'
    enabledFlags creditNote, ['isLoaded', 'isValid']
    expect(creditNote).toEqual store.find(Vosae.CreditNote, 1)

  it 'finding creditNotes by query makes a GET to /credit_note/:query/', ->
    # Setup
    creditNotes = store.find Vosae.CreditNote, {state: "DRAFT"}

    # Test
    expect(creditNotes.get('length')).toEqual 0
    enabledFlags creditNotes, ['isLoading'], recordArrayFlags
    expectAjaxURL "/credit_note/"
    expectAjaxType "GET"
    expectAjaxData({state: "DRAFT"})

    # Setup
    ajaxHash.success(
      meta: {}
      objects: [
        $.extend {}, hashCreditNote, {id: 1, state: "DRAFT"}
        $.extend {}, hashCreditNote, {id: 2, state: "DRAFT"}
      ]
    )
    creditNote1 = creditNotes.objectAt 0
    creditNote2 = creditNotes.objectAt 1

    # Test
    statesEqual [creditNote1, creditNote2], 'loaded.saved'
    enabledFlags creditNotes, ['isLoaded'], recordArrayFlags
    enabledFlagsForArray [creditNote1, creditNote2], ['isLoaded'], recordArrayFlags
    expect(creditNotes.get('length')).toEqual 2
    expect(creditNote1.get('state')).toEqual "DRAFT"
    expect(creditNote2.get('state')).toEqual "DRAFT"
    expect(creditNote1.get('id')).toEqual "1"
    expect(creditNote2.get('id')).toEqual "2"

  it 'relatedColor property should return green', ->
    # Setup
    store.adapterForType(Vosae.CreditNote).load store, Vosae.CreditNote, {id: 1}
    creditNote = store.find Vosae.CreditNote, 1

    # Test
    expect(creditNote.get('relatedColor')).toEqual "green"

  it 'isInvoice property should return false', ->
    # Setup
    store.adapterForType(Vosae.CreditNote).load store, Vosae.CreditNote, {id: 1}
    creditNote = store.find Vosae.CreditNote, 1

    # Test
    expect(creditNote.get('isInvoice')).toBeFalsy()

  it 'isQuotation property should return false', ->
    # Setup
    store.adapterForType(Vosae.CreditNote).load store, Vosae.CreditNote, {id: 1}
    creditNote = store.find Vosae.CreditNote, 1

    # Test
    expect(creditNote.get('isQuotation')).toBeFalsy()

  it 'isCreditNote property should return true', ->
    # Setup
    store.adapterForType(Vosae.CreditNote).load store, Vosae.CreditNote, {id: 1}
    creditNote = store.find Vosae.CreditNote, 1

    # Test
    expect(creditNote.get('isCreditNote')).toBeTruthy

  it 'relatedInvoice belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    invoice = store.find Vosae.Invoice, 1
    store.adapterForType(Vosae.CreditNote).load store, Vosae.CreditNote, {id: 1, related_invoice: "/api/v1/invoice/1/"}
    creditNote = store.find Vosae.CreditNote, 1

    # Test
    expect(creditNote.get('relatedInvoice')).toEqual invoice
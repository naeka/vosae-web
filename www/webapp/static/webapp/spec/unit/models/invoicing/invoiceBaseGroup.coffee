store = null

describe 'Vosae.InvoiceBaseGroup', ->
  beforeEach ->
    store = Vosae.Store.create()

  afterEach ->
    store.destroy()

  it 'quotation belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.Quotation).load store, Vosae.Quotation, {id: 1}
    store.adapterForType(Vosae.InvoiceBaseGroup).load store, Vosae.InvoiceBaseGroup, {id: 1, quotation: "/api/v1/quotation/1/"}
    quotation = store.find Vosae.Quotation, 1
    invoiceBaseGroup = store.find Vosae.InvoiceBaseGroup, 1

    # Test
    expect(invoiceBaseGroup.get('quotation')).toEqual quotation

  it 'purchaseOrder belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.PurchaseOrder).load store, Vosae.PurchaseOrder, {id: 1}
    store.adapterForType(Vosae.InvoiceBaseGroup).load store, Vosae.InvoiceBaseGroup, {id: 1, purchase_order: "/api/v1/purcharse_order/1/"}
    purchaseOrder = store.find Vosae.PurchaseOrder, 1
    invoiceBaseGroup = store.find Vosae.InvoiceBaseGroup, 1

    # Test
    expect(invoiceBaseGroup.get('purchaseOrder')).toEqual purchaseOrder

  it 'downPaymentInvoices hasMany relationship', ->
    # Setup
    store.adapterForType(Vosae.DownPaymentInvoice).load store, Vosae.DownPaymentInvoice, {id: 1}
    store.adapterForType(Vosae.InvoiceBaseGroup).load store, Vosae.InvoiceBaseGroup,
      id: 1
      down_payment_invoices: ["/api/v1/down_payment_invoice/1/"]
    invoiceBaseGroup = store.find Vosae.InvoiceBaseGroup, 1
    downPaymentInvoice = store.find Vosae.DownPaymentInvoice, 1

    # Test
    expect(invoiceBaseGroup.get('downPaymentInvoices.firstObject')).toEqual downPaymentInvoice

  it 'can add downPaymentInvoices', ->
    # Setup
    store.adapterForType(Vosae.InvoiceBaseGroup).load store, Vosae.InvoiceBaseGroup, {id: 1}
    invoiceBaseGroup = store.find Vosae.InvoiceBaseGroup, 1
    downPayment = invoiceBaseGroup.get('downPaymentInvoices').createRecord()
    downPayment2 = invoiceBaseGroup.get('downPaymentInvoices').createRecord()   

    # Test
    expect(invoiceBaseGroup.get('downPaymentInvoices.length')).toEqual 2
    expect(invoiceBaseGroup.get('downPaymentInvoices').objectAt(0)).toEqual downPayment
    expect(invoiceBaseGroup.get('downPaymentInvoices').objectAt(1)).toEqual downPayment2

  it 'can delete downPaymentInvoices', ->
    # Setup
    store.adapterForType(Vosae.InvoiceBaseGroup).load store, Vosae.InvoiceBaseGroup, {id: 1}
    invoiceBaseGroup = store.find Vosae.InvoiceBaseGroup, 1
    downPayment = invoiceBaseGroup.get('downPaymentInvoices').createRecord()
    downPayment2 = invoiceBaseGroup.get('downPaymentInvoices').createRecord()

    # Test
    expect(invoiceBaseGroup.get('downPaymentInvoices.length')).toEqual 2

    # Setup
    invoiceBaseGroup.get('downPaymentInvoices').removeObject downPayment
    invoiceBaseGroup.get('downPaymentInvoices').removeObject downPayment2

    # Test
    expect(invoiceBaseGroup.get('downPaymentInvoices.length')).toEqual 0

  it 'invoice belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    store.adapterForType(Vosae.InvoiceBaseGroup).load store, Vosae.InvoiceBaseGroup, {id: 1, invoice: "/api/v1/invoice/1/"}
    invoice = store.find Vosae.Invoice, 1
    invoiceBaseGroup = store.find Vosae.InvoiceBaseGroup, 1

    # Test
    expect(invoiceBaseGroup.get('invoice')).toEqual invoice

  it 'invoicesCancelled hasMany relationship', ->
    # Setup
    store.adapterForType(Vosae.Invoice).load store, Vosae.Invoice, {id: 1}
    store.adapterForType(Vosae.InvoiceBaseGroup).load store, Vosae.InvoiceBaseGroup,
      id: 1
      invoices_cancelled: ["/api/v1/invoice/1/"]
    invoiceBaseGroup = store.find Vosae.InvoiceBaseGroup, 1
    invoiceCancelled = store.find Vosae.Invoice, 1

    # Test
    expect(invoiceBaseGroup.get('invoicesCancelled.firstObject')).toEqual invoiceCancelled

  it 'can add invoicesCancelled', ->
    # Setup
    store.adapterForType(Vosae.InvoiceBaseGroup).load store, Vosae.InvoiceBaseGroup, {id: 1}
    invoiceBaseGroup = store.find Vosae.InvoiceBaseGroup, 1
    invoiceCancelled = invoiceBaseGroup.get('invoicesCancelled').createRecord()
    invoiceCancelled2 = invoiceBaseGroup.get('invoicesCancelled').createRecord()   

    # Test
    expect(invoiceBaseGroup.get('invoicesCancelled.length')).toEqual 2
    expect(invoiceBaseGroup.get('invoicesCancelled').objectAt(0)).toEqual invoiceCancelled
    expect(invoiceBaseGroup.get('invoicesCancelled').objectAt(1)).toEqual invoiceCancelled2

  it 'can delete invoicesCancelled', ->
    # Setup
    store.adapterForType(Vosae.InvoiceBaseGroup).load store, Vosae.InvoiceBaseGroup, {id: 1}
    invoiceBaseGroup = store.find Vosae.InvoiceBaseGroup, 1
    invoiceCancelled = invoiceBaseGroup.get('invoicesCancelled').createRecord()
    invoiceCancelled2 = invoiceBaseGroup.get('invoicesCancelled').createRecord()

    # Test
    expect(invoiceBaseGroup.get('invoicesCancelled.length')).toEqual 2

    # Setup
    invoiceBaseGroup.get('invoicesCancelled').removeObject invoiceCancelled
    invoiceBaseGroup.get('invoicesCancelled').removeObject invoiceCancelled2

    # Test
    expect(invoiceBaseGroup.get('invoicesCancelled.length')).toEqual 0

  it 'creditNotes hasMany relationship', ->
    # Setup
    store.adapterForType(Vosae.CreditNote).load store, Vosae.CreditNote, {id: 1}
    store.adapterForType(Vosae.InvoiceBaseGroup).load store, Vosae.InvoiceBaseGroup,
      id: 1
      credit_notes: ["/api/v1/credit_note/1/"]
    invoiceBaseGroup = store.find Vosae.InvoiceBaseGroup, 1
    creditNote = store.find Vosae.CreditNote, 1

    # Test
    expect(invoiceBaseGroup.get('creditNotes.firstObject')).toEqual creditNote

  it 'can add creditNotes', ->
    # Setup
    store.adapterForType(Vosae.InvoiceBaseGroup).load store, Vosae.InvoiceBaseGroup, {id: 1}
    invoiceBaseGroup = store.find Vosae.InvoiceBaseGroup, 1
    creditNote = invoiceBaseGroup.get('creditNotes').createRecord()
    creditNote2 = invoiceBaseGroup.get('creditNotes').createRecord()   

    # Test
    expect(invoiceBaseGroup.get('creditNotes.length')).toEqual 2
    expect(invoiceBaseGroup.get('creditNotes').objectAt(0)).toEqual creditNote
    expect(invoiceBaseGroup.get('creditNotes').objectAt(1)).toEqual creditNote2

  it 'can delete creditNotes', ->
    # Setup
    store.adapterForType(Vosae.InvoiceBaseGroup).load store, Vosae.InvoiceBaseGroup, {id: 1}
    invoiceBaseGroup = store.find Vosae.InvoiceBaseGroup, 1
    creditNote = invoiceBaseGroup.get('creditNotes').createRecord()
    creditNote2 = invoiceBaseGroup.get('creditNotes').createRecord()

    # Test
    expect(invoiceBaseGroup.get('creditNotes.length')).toEqual 2

    # Setup
    invoiceBaseGroup.get('creditNotes').removeObject creditNote
    invoiceBaseGroup.get('creditNotes').removeObject creditNote2

    # Test
    expect(invoiceBaseGroup.get('creditNotes.length')).toEqual 0
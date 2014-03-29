env = undefined
store = undefined

module "DS.Model / Vosae.Timeline",
  setup: ->
    env = setupStore()

    # Register transforms
    env.container.register 'transform:datetime', Vosae.DatetimeTransform

    # Make the store available for all tests
    store = env.store

test 'relationship - issuer', ->
  # Setup
  store.push 'user', {id: 1, fullName: 'Thomas Durin'}
  store.push 'timeline', {id: 1, issuer: 1}

  # Test
  store.find('timeline', 1).then async (timeline) ->
    equal timeline.get('issuer') instanceof Vosae.User, true, "the issuer property should return a user"
    equal timeline.get('issuer.fullName'), "Thomas Durin", "the issuer should have a name"

test 'computedProperty - dateFormated', ->
  # Setup
  store.push 'timeline', {id: 1, datetime: new Date(2011,10,30)}

  # Test
  store.find('timeline', 1).then async (timeline) ->
    equal timeline.get('dateFormated'), "November 30 2011", "the dateFormated property display the datetime date"


module "DS.Model / Vosae.Timeline / Vosae.ContactSavedTE",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'relationship - contact', ->
  # Setup
  store.push 'contact', {id: 1, name: 'Thomas Durin'}
  store.push 'contactSavedTE', {id: 1, contact: 1}

  # Test
  store.find('contactSavedTE', 1).then async (timeline) ->
    equal timeline.get('contact') instanceof Vosae.Contact, true, "the contact property should return a user"
    equal timeline.get('contact.name'), "Thomas Durin", "the contact should have a name"


module "DS.Model / Vosae.Timeline / Vosae.OrganizationSavedTE",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'relationship - organization', ->
  # Setup
  store.push 'organization', {id: 1, corporateName: 'Naeka'}
  store.push 'organizationSavedTE', {id: 1, organization: 1}

  # Test
  store.find('organizationSavedTE', 1).then async (timeline) ->
    equal timeline.get('organization') instanceof Vosae.Organization, true, "the organization property should return an organization"
    equal timeline.get('organization.corporateName'), "Naeka", "the organization should have a corporate name"


module "DS.Model / Vosae.Timeline / Vosae.QuotationSavedTE",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'relationship - quotation', ->
  # Setup
  store.push 'quotation', {id: 1, reference: '001'}
  store.push 'quotationSavedTE', {id: 1, quotation: 1}

  # Test
  store.find('quotationSavedTE', 1).then async (timeline) ->
    equal timeline.get('quotation') instanceof Vosae.Quotation, true, "the quotation property should return a quotation"
    equal timeline.get('quotation.reference'), "001", "the quotation should have a reference"


module "DS.Model / Vosae.Timeline / Vosae.InvoiceSavedTE",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'relationship - invoice', ->
  # Setup
  store.push 'invoice', {id: 1, reference: '001'}
  store.push 'invoiceSavedTE', {id: 1, invoice: 1}

  # Test
  store.find('invoiceSavedTE', 1).then async (timeline) ->
    equal timeline.get('invoice') instanceof Vosae.Invoice, true, "the invoice property should return a invoice"
    equal timeline.get('invoice.reference'), "001", "the invoice should have a reference"


module "DS.Model / Vosae.Timeline / Vosae.DownPaymentInvoiceSavedTE",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'relationship - downPaymentInvoice', ->
  # Setup
  store.push 'downPaymentInvoice', {id: 1, reference: '001'}
  store.push 'downPaymentInvoiceSavedTE', {id: 1, downPaymentInvoice: 1}

  # Test
  store.find('downPaymentInvoiceSavedTE', 1).then async (timeline) ->
    equal timeline.get('downPaymentInvoice') instanceof Vosae.DownPaymentInvoice, true, "the downPaymentInvoice property should return a down payment invoice"
    equal timeline.get('downPaymentInvoice.reference'), "001", "the down payment invoice should have a reference"


module "DS.Model / Vosae.Timeline / Vosae.CreditNoteSavedTE",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'relationship - creditNote', ->
  # Setup
  store.push 'creditNote', {id: 1, reference: '001'}
  store.push 'creditNoteSavedTE', {id: 1, creditNote: 1}

  # Test
  store.find('creditNoteSavedTE', 1).then async (timeline) ->
    equal timeline.get('creditNote') instanceof Vosae.CreditNote, true, "the creditNote property should return a credit note"
    equal timeline.get('creditNote.reference'), "001", "the credit note should have a reference"


module "DS.Model / Vosae.Timeline / Vosae.QuotationChangedStateTE",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'relationship - quotation', ->
  # Setup
  store.push 'quotation', {id: 1, reference: '001'}
  store.push 'quotationChangedStateTE', {id: 1, quotation: 1}

  # Test
  store.find('quotationChangedStateTE', 1).then async (timeline) ->
    equal timeline.get('quotation') instanceof Vosae.Quotation, true, "the quotation property should return a quotation"
    equal timeline.get('quotation.reference'), "001", "the quotation should have a reference"


module "DS.Model / Vosae.Timeline / Vosae.InvoiceChangedStateTE",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'relationship - invoice', ->
  # Setup
  store.push 'invoice', {id: 1, reference: '001'}
  store.push 'invoiceChangedStateTE', {id: 1, invoice: 1}

  # Test
  store.find('invoiceChangedStateTE', 1).then async (timeline) ->
    equal timeline.get('invoice') instanceof Vosae.Invoice, true, "the invoice property should return a invoice"
    equal timeline.get('invoice.reference'), "001", "the invoice should have a reference"


module "DS.Model / Vosae.Timeline / Vosae.DownPaymentInvoiceChangedStateTE",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'relationship - downPaymentInvoice', ->
  # Setup
  store.push 'downPaymentInvoice', {id: 1, reference: '001'}
  store.push 'downPaymentInvoiceChangedStateTE', {id: 1, downPaymentInvoice: 1}

  # Test
  store.find('downPaymentInvoiceChangedStateTE', 1).then async (timeline) ->
    equal timeline.get('downPaymentInvoice') instanceof Vosae.DownPaymentInvoice, true, "the downPaymentInvoice property should return a down payment invoice"
    equal timeline.get('downPaymentInvoice.reference'), "001", "the down payment invoice should have a reference"


module "DS.Model / Vosae.Timeline / Vosae.CreditNoteChangedStateTE",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'relationship - creditNote', ->
  # Setup
  store.push 'creditNote', {id: 1, reference: '001'}
  store.push 'creditNoteChangedStateTE', {id: 1, creditNote: 1}

  # Test
  store.find('creditNoteChangedStateTE', 1).then async (timeline) ->
    equal timeline.get('creditNote') instanceof Vosae.CreditNote, true, "the creditNote property should return a credit note"
    equal timeline.get('creditNote.reference'), "001", "the credit note should have a reference"


module "DS.Model / Vosae.Timeline / Vosae.QuotationAddedAttachmentTE",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'relationship - quotation', ->
  # Setup
  store.push 'quotation', {id: 1, reference: '001'}
  store.push 'quotationAddedAttachmentTE', {id: 1, quotation: 1}

  # Test
  store.find('quotationAddedAttachmentTE', 1).then async (timeline) ->
    equal timeline.get('quotation') instanceof Vosae.Quotation, true, "the quotation property should return a quotation"
    equal timeline.get('quotation.reference'), "001", "the quotation should have a reference"

 test 'relationship - vosaeFile', ->
  # Setup
  store.push 'file', {id: 1, name: 'file.jpg'}
  store.push 'quotationAddedAttachmentTE', {id: 1, vosaeFile: 1}

  # Test
  store.find('quotationAddedAttachmentTE', 1).then async (timeline) ->
    equal timeline.get('vosaeFile') instanceof Vosae.File, true, "the vosaeFile property should return a file"
    equal timeline.get('vosaeFile.name'), "file.jpg", "the vosaeFile should have a name"


module "DS.Model / Vosae.Timeline / Vosae.InvoiceAddedAttachmentTE",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'relationship - invoice', ->
  # Setup
  store.push 'invoice', {id: 1, reference: '001'}
  store.push 'invoiceAddedAttachmentTE', {id: 1, invoice: 1}

  # Test
  store.find('invoiceAddedAttachmentTE', 1).then async (timeline) ->
    equal timeline.get('invoice') instanceof Vosae.Invoice, true, "the invoice property should return an invoice"
    equal timeline.get('invoice.reference'), "001", "the invoice should have a reference"

test 'relationship - vosaeFile', ->
  # Setup
  store.push 'file', {id: 1, name: 'file.jpg'}
  store.push 'invoiceAddedAttachmentTE', {id: 1, vosaeFile: 1 }

  # Test
  store.find('invoiceAddedAttachmentTE', 1).then async (timeline) ->
    equal timeline.get('vosaeFile') instanceof Vosae.File, true, "the vosaeFile property should return a file"
    equal timeline.get('vosaeFile.name'), "file.jpg", "the vosaeFile should have a name"


module "DS.Model / Vosae.Timeline / Vosae.DownPaymentInvoiceAddedAttachmentTE",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'relationship - downPaymentInvoice', ->
  # Setup
  store.push 'downPaymentInvoice', {id: 1, reference: '001'}
  store.push 'downPaymentInvoiceAddedAttachmentTE', {id: 1, downPaymentInvoice: 1}

  # Test
  store.find('downPaymentInvoiceAddedAttachmentTE', 1).then async (timeline) ->
    equal timeline.get('downPaymentInvoice') instanceof Vosae.DownPaymentInvoice, true, "the downPaymentInvoice property should return a down payment invoice"
    equal timeline.get('downPaymentInvoice.reference'), "001", "the down payment invoice should have a reference"

test 'relationship - vosaeFile', ->
  # Setup
  store.push 'file', {id: 1, name: 'file.jpg'}
  store.push 'downPaymentInvoiceAddedAttachmentTE', {id: 1, vosaeFile: 1}

  # Test
  store.find('downPaymentInvoiceAddedAttachmentTE', 1).then async (timeline) ->
    equal timeline.get('vosaeFile') instanceof Vosae.File, true, "the vosaeFile property should return a file"
    equal timeline.get('vosaeFile.name'), "file.jpg", "the vosaeFile should have a name"


module "DS.Model / Vosae.Timeline / Vosae.CreditNoteAddedAttachmentTE",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'relationship - creditNote', ->
  # Setup
  store.push 'creditNote', {id: 1, reference: '001'}
  store.push 'creditNoteAddedAttachmentTE', {id: 1, creditNote: 1}

  # Test
  store.find('creditNoteAddedAttachmentTE', 1).then async (timeline) ->
    equal timeline.get('creditNote') instanceof Vosae.CreditNote, true, "the creditNote property should return a credit note"
    equal timeline.get('creditNote.reference'), "001", "the credit note should have a reference"

test 'relationship - vosaeFile', ->
  # Setup
  store.push 'file', {id: 1, name: 'file.jpg'}
  store.push 'creditNoteAddedAttachmentTE', {id: 1, vosaeFile: 1}

  # Test
  store.find('creditNoteAddedAttachmentTE', 1).then async (timeline) ->
    equal timeline.get('vosaeFile') instanceof Vosae.File, true, "the vosaeFile property should return a file"
    equal timeline.get('vosaeFile.name'), "file.jpg", "the vosaeFile should have a name"


module "DS.Model / Vosae.Timeline / Vosae.QuotationMakeInvoiceTE",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'relationship - quotation', ->
  # Setup
  store.push 'quotation', {id: 1, reference: "001"}
  store.push 'quotationMakeInvoiceTE', {id: 1, quotation: 1}

  # Test
  store.find('quotationMakeInvoiceTE', 1).then async (timeline) ->
    equal timeline.get('quotation') instanceof Vosae.Quotation, true, "the quotation property should return a quotation"
    equal timeline.get('quotation.reference'), "001", "the quotation should have a reference"

test 'relationship - invoice', ->
  # Setup
  store.push 'invoice', {id: 1, reference: "001"}
  store.push 'quotationMakeInvoiceTE', {id: 1, invoice: 1}

  # Test
  store.find('quotationMakeInvoiceTE', 1).then async (timeline) ->
    equal timeline.get('invoice') instanceof Vosae.Invoice, true, "the invoice property should return an invoice"
    equal timeline.get('invoice.reference'), "001", "the invoice should have a reference"


module "DS.Model / Vosae.Timeline / Vosae.QuotationMakeDownPaymentInvoiceTE",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'relationship - quotation', ->
  # Setup
  store.push 'quotation', {id: 1, reference: "001"}
  store.push 'quotationMakeDownPaymentInvoiceTE', {id: 1, quotation: 1}

  # Test
  store.find('quotationMakeDownPaymentInvoiceTE', 1).then async (timeline) ->
    equal timeline.get('quotation') instanceof Vosae.Quotation, true, "the quotation property should return a quotation"
    equal timeline.get('quotation.reference'), "001", "the quotation should have a reference"

test 'relationship - downPaymentInvoice', ->
  # Setup
  store.push 'downPaymentInvoice', {id: 1, reference: "001"}
  store.push 'quotationMakeDownPaymentInvoiceTE', {id: 1, downPaymentInvoice: 1}

  # Test
  store.find('quotationMakeDownPaymentInvoiceTE', 1).then async (timeline) ->
    equal timeline.get('downPaymentInvoice') instanceof Vosae.DownPaymentInvoice, true, "the downPaymentInvoice property should return a down payment invoice"
    equal timeline.get('downPaymentInvoice.reference'), "001", "the down payment invoice should have a reference"


module "DS.Model / Vosae.Timeline / Vosae.InvoiceCancelledTE",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'relationship - invoice', ->
  # Setup
  store.push 'invoice', {id: 1, reference: "001"}
  store.push 'invoiceCancelledTE', {id: 1, invoice: 1}

  # Test
  store.find('invoiceCancelledTE', 1).then async (timeline) ->
    equal timeline.get('invoice') instanceof Vosae.Invoice, true, "the invoice property should return an invoice"
    equal timeline.get('invoice.reference'), "001", "the invoice should have a reference"

test 'relationship - creditNote', ->
  # Setup
  store.push 'creditNote', {id: 1, reference: "001"}
  store.push 'invoiceCancelledTE', {id: 1, creditNote: 1}

  # Test
  store.find('invoiceCancelledTE', 1).then async (timeline) ->
    equal timeline.get('creditNote') instanceof Vosae.CreditNote, true, "the creditNote property should return a credit note"
    equal timeline.get('creditNote.reference'), "001", "the credit note should have a reference"


module "DS.Model / Vosae.Timeline / Vosae.DownPaymentInvoiceCancelledTE",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'relationship - downPaymentInvoice', ->
  # Setup
  store.push 'downPaymentInvoice', {id: 1, reference: "001"}
  store.push 'downPaymentInvoiceCancelledTE', {id: 1, downPaymentInvoice: 1}

  # Test
  store.find('downPaymentInvoiceCancelledTE', 1).then async (timeline) ->
    equal timeline.get('downPaymentInvoice') instanceof Vosae.DownPaymentInvoice, true, "the downPaymentInvoice property should return a down payment invoice"
    equal timeline.get('downPaymentInvoice.reference'), "001", "the down payment invoice should have a reference"

test 'relationship - creditNote', ->
  # Setup
  store.push 'creditNote', {id: 1, reference: "001"}
  store.push 'downPaymentInvoiceCancelledTE', {id: 1, creditNote: 1}

  # Test
  store.find('downPaymentInvoiceCancelledTE', 1).then async (timeline) ->
    equal timeline.get('creditNote') instanceof Vosae.CreditNote, true, "the creditNote property should return a credit note"
    equal timeline.get('creditNote.reference'), "001", "the credit note should have a reference"
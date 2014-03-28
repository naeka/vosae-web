env = undefined
store = undefined

module "DS.Model / Vosae.Notification / Vosae.ContactSavedNE",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'relationship - contact', ->
  # Setup
  store.push 'contact', {id: 1, name: 'Thomas Durin'}
  store.push 'contactSavedNE', {id: 1, contact: 1}

  # Test
  store.find('contactSavedNE', 1).then async (notif) ->
    equal notif.get('contact') instanceof Vosae.Contact, true, "the contact property should return a user"
    equal notif.get('contact.name'), "Thomas Durin", "the contact should have a name"


module "DS.Model / Vosae.Notification / Vosae.OrganizationSavedNE",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'relationship - organization', ->
  # Setup
  store.push 'organization', {id: 1, corporateName: 'Naeka'}
  store.push 'organizationSavedNE', {id: 1, organization: 1}

  # Test
  store.find('organizationSavedNE', 1).then async (notif) ->
    equal notif.get('organization') instanceof Vosae.Organization, true, "the organization property should return an organization"
    equal notif.get('organization.corporateName'), "Naeka", "the organization should have a corporate name"


module "DS.Model / Vosae.Notification / Vosae.QuotationSavedNE",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'relationship - quotation', ->
  # Setup
  store.push 'quotation', {id: 1, reference: '001'}
  store.push 'quotationSavedNE', {id: 1, quotation: 1}

  # Test
  store.find('quotationSavedNE', 1).then async (notif) ->
    equal notif.get('quotation') instanceof Vosae.Quotation, true, "the quotation property should return a quotation"
    equal notif.get('quotation.reference'), "001", "the quotation should have a reference"


module "DS.Model / Vosae.Notification / Vosae.InvoiceSavedNE",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'relationship - invoice', ->
  # Setup
  store.push 'invoice', {id: 1, reference: '001'}
  store.push 'invoiceSavedNE', {id: 1, invoice: 1}

  # Test
  store.find('invoiceSavedNE', 1).then async (notif) ->
    equal notif.get('invoice') instanceof Vosae.Invoice, true, "the invoice property should return a invoice"
    equal notif.get('invoice.reference'), "001", "the invoice should have a reference"


module "DS.Model / Vosae.Notification / Vosae.DownPaymentInvoiceSavedNE",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'relationship - downPaymentInvoice', ->
  # Setup
  store.push 'downPaymentInvoice', {id: 1, reference: '001'}
  store.push 'downPaymentInvoiceSavedNE', {id: 1, downPaymentInvoice: 1}

  # Test
  store.find('downPaymentInvoiceSavedNE', 1).then async (notif) ->
    equal notif.get('downPaymentInvoice') instanceof Vosae.DownPaymentInvoice, true, "the downPaymentInvoice property should return a down payment invoice"
    equal notif.get('downPaymentInvoice.reference'), "001", "the down payment invoice should have a reference"


module "DS.Model / Vosae.Notification / Vosae.CreditNoteSavedNE",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'relationship - creditNote', ->
  # Setup
  store.push 'creditNote', {id: 1, reference: '001'}
  store.push 'creditNoteSavedNE', {id: 1, creditNote: 1}

  # Test
  store.find('creditNoteSavedNE', 1).then async (notif) ->
    equal notif.get('creditNote') instanceof Vosae.CreditNote, true, "the creditNote property should return a credit note"
    equal notif.get('creditNote.reference'), "001", "the credit note should have a reference"


module "DS.Model / Vosae.Notification / Vosae.EventReminderNE",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'relationship - vosaeEvent', ->
  # Setup
  store.push 'vosaeEvent', {id: 1, summary: 'Birthday'}
  store.push 'eventReminderNE', {id: 1, vosaeEvent: 1}

  # Test
  store.find('eventReminderNE', 1).then async (notif) ->
    equal notif.get('vosaeEvent') instanceof Vosae.VosaeEvent, true, "the eventReminder property should return a vosae event"
    equal notif.get('vosaeEvent.summary'), "Birthday", "the credit note should have a summary"
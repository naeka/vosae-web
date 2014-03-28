# store = null

# describe 'Vosae.Timeline', ->
#   hashTimelineEntry = 
#     datetime: undefined
#     created: false
#     module: null
#     issuer_name: null

#   beforeEach ->
#     comp = getAdapterForTest(Vosae.Timeline)
#     ajaxUrl = comp[0]
#     ajaxType = comp[1]
#     ajaxHash = comp[2]
#     store = comp[3]

#   afterEach ->
#     comp = undefined
#     ajaxUrl = undefined
#     ajaxType = undefined
#     ajaxHash = undefined
#     store.destroy()

#   it 'finding all timeline entries makes a GET to /timeline/', ->
#     # Setup
#     timelineEntries = store.find Vosae.Timeline
    
#     # Test
#     enabledFlags timelineEntries, ['isLoaded', 'isValid'], recordArrayFlags
#     expectAjaxURL "/timeline/"
#     expectAjaxType "GET"

#     # Setup
#     ajaxHash.success(
#       meta: {}
#       objects: [$.extend({}, hashTimelineEntry, {id: 1, created: false})]
#     )
#     timelineEntry = timelineEntries.objectAt(0)

#     # Test
#     statesEqual timelineEntries, 'loaded.saved'
#     stateEquals timelineEntry, 'loaded.saved'
#     enabledFlagsForArray timelineEntries, ['isLoaded', 'isValid']
#     enabledFlags timelineEntry, ['isLoaded', 'isValid']
#     expect(timelineEntry).toEqual store.find(Vosae.Timeline, 1)


#   it 'finding a timeline entry by ID makes a GET to /timeline/:id/', ->
#     # Setup
#     timelineEntry = store.find Vosae.Timeline, 1
#     ajaxHash.success($.extend, {}, hashTimelineEntry, {id: 1, created: false})

#     # Test
#     expectAjaxType "GET"
#     expectAjaxURL "/timeline/1/"
#     expect(timelineEntry).toEqual store.find(Vosae.Timeline, 1)

#   it 'polymorph contact_saved_te', ->
#     # Setup
#     store.load Vosae.Contact, {id: 1}
#     contact = store.find Vosae.Contact, 1
#     timelineEntry = store.find Vosae.ContactSavedTE, 1
#     ajaxHash.success $.extend({}, hashTimelineEntry, {
#       id: 1
#       created: false
#       resource_type: "contact_saved_te"
#       contact_name: "Tom Dale"
#       contact: "/api/v1/contact/1/"
#     })

#     # Test
#     expectAjaxType "GET"
#     expectAjaxURL "/timeline/1/"
#     expect(timelineEntry.get('contactName')).toEqual "Tom Dale"
#     expect(timelineEntry.get('contact')).toEqual contact

#   it 'polymorph organization_saved_te', ->
#     # Setup
#     store.load Vosae.Organization, {id: 1}
#     organization = store.find Vosae.Organization, 1
#     timelineEntry = store.find Vosae.OrganizationSavedTE, 1
#     ajaxHash.success $.extend({}, hashTimelineEntry, {
#       id: 1
#       resource_type: "organization_saved_te"
#       organization_name: "Naeka"
#       organization: "/api/v1/organization/1/"
#     })

#     # Test
#     expectAjaxType "GET"
#     expectAjaxURL "/timeline/1/"
#     expect(timelineEntry.get('organizationName')).toEqual "Naeka"
#     expect(timelineEntry.get('organization')).toEqual organization

#   it 'polymorph quotation_saved_te', ->
#     # Setup
#     store.load Vosae.Quotation, {id: 1}
#     quotation = store.find Vosae.Quotation, 1
#     timelineEntry = store.find Vosae.QuotationSavedTE, 1
#     ajaxHash.success $.extend({}, hashTimelineEntry, {
#       id: 1
#       customer_display: "Naeka"
#       quotation_reference: "QUOTATION 2013_12_04_001"
#       quotation: "/api/v1/quotation/1/"
#     })

#     # Test
#     expectAjaxType "GET"
#     expectAjaxURL "/timeline/1/"
#     expect(timelineEntry.get('customerDisplay')).toEqual "Naeka"
#     expect(timelineEntry.get('quotationReference')).toEqual "QUOTATION 2013_12_04_001"
#     expect(timelineEntry.get('quotation')).toEqual quotation

#   it 'polymorph invoice_saved_te', ->
#     # Setup
#     store.load Vosae.Invoice, {id: 1}
#     invoice = store.find Vosae.Invoice, 1
#     timelineEntry = store.find Vosae.InvoiceSavedTE, 1
#     ajaxHash.success $.extend({}, hashTimelineEntry, {
#       id: 1
#       customer_display: "Naeka"
#       invoice_reference: "INVOICE 2013_12_04_001"
#       invoice: "/api/v1/invoice/1/"
#       invoice_has_temporary_reference: true
#     })

#     # Test
#     expectAjaxType "GET"
#     expectAjaxURL "/timeline/1/"
#     expect(timelineEntry.get('customerDisplay')).toEqual "Naeka"
#     expect(timelineEntry.get('invoiceReference')).toEqual "INVOICE 2013_12_04_001"
#     expect(timelineEntry.get('invoiceHasTemporaryReference')).toEqual true
#     expect(timelineEntry.get('invoice')).toEqual invoice

#   it 'polymorph down_payment_invoice_saved_te', ->
#     # Setup
#     store.load Vosae.DownPaymentInvoice, {id: 1}
#     downPaymentInvoice = store.find Vosae.DownPaymentInvoice, 1
#     timelineEntry = store.find Vosae.DownPaymentInvoiceSavedTE, 1
#     ajaxHash.success $.extend({}, hashTimelineEntry, {
#       id: 1
#       customer_display: "Naeka"
#       down_payment_invoice_reference: "DOWNPAYMENTINVOICE 2013_12_04_001"
#       down_payment_invoice: "/api/v1/down_payment_invoice/1/"
#     })

#     # Test
#     expectAjaxType "GET"
#     expectAjaxURL "/timeline/1/"
#     expect(timelineEntry.get('customerDisplay')).toEqual "Naeka"
#     expect(timelineEntry.get('downPaymentInvoiceReference')).toEqual "DOWNPAYMENTINVOICE 2013_12_04_001"
#     expect(timelineEntry.get('downPaymentInvoice')).toEqual downPaymentInvoice

#   it 'polymorph credit_note_saved_te', ->
#     # Setup
#     store.load Vosae.CreditNote, {id: 1}
#     creditNote = store.find Vosae.CreditNote, 1
#     timelineEntry = store.find Vosae.CreditNoteSavedTE, 1
#     ajaxHash.success $.extend({}, hashTimelineEntry, {
#       id: 1
#       customer_display: "Naeka"
#       credit_note_reference: "CREDITNOTE 2013_12_04_001"
#       credit_note: "/api/v1/credit_note/1/"
#     })

#     # Test
#     expectAjaxType "GET"
#     expectAjaxURL "/timeline/1/"
#     expect(timelineEntry.get('customerDisplay')).toEqual "Naeka"
#     expect(timelineEntry.get('creditNoteReference')).toEqual "CREDITNOTE 2013_12_04_001"
#     expect(timelineEntry.get('creditNote')).toEqual creditNote
 
#   it 'polymorph quotation_changed_state_te', ->
#     # Setup
#     store.load Vosae.Quotation, {id: 1}
#     quotation = store.find Vosae.Quotation, 1
#     timelineEntry = store.find Vosae.QuotationChangedStateTE, 1
#     ajaxHash.success $.extend({}, hashTimelineEntry, {
#       id: 1
#       previous_state: "DRAFT"
#       new_state: "AWAITING_APPROVAL"
#       quotation_reference: "QUOTATION 2013_12_04_001"
#       quotation: "/api/v1/quotation/1/"
#     })

#     # Test
#     expectAjaxType "GET"
#     expectAjaxURL "/timeline/1/"
#     expect(timelineEntry.get('previousState')).toEqual "DRAFT"
#     expect(timelineEntry.get('newState')).toEqual "AWAITING_APPROVAL"
#     expect(timelineEntry.get('quotationReference')).toEqual "QUOTATION 2013_12_04_001"
#     expect(timelineEntry.get('quotation')).toEqual quotation

#   it 'polymorph invoice_changed_state_te', ->
#     # Setup
#     store.load Vosae.Invoice, {id: 1}
#     invoice = store.find Vosae.Invoice, 1
#     timelineEntry = store.find Vosae.InvoiceChangedStateTE, 1
#     ajaxHash.success $.extend({}, hashTimelineEntry, {
#       id: 1
#       previous_state: "DRAFT"
#       new_state: "REGISTERED"
#       invoice_reference: "INVOICE 2013_12_04_001"
#       invoice: "/api/v1/invoice/1/"
#     })

#     # Test
#     expectAjaxType "GET"
#     expectAjaxURL "/timeline/1/"
#     expect(timelineEntry.get('previousState')).toEqual "DRAFT"
#     expect(timelineEntry.get('newState')).toEqual "REGISTERED"
#     expect(timelineEntry.get('invoiceReference')).toEqual "INVOICE 2013_12_04_001"
#     expect(timelineEntry.get('invoice')).toEqual invoice 

#   it 'polymorph down_payment_invoice_changed_state_te', ->
#     # Setup
#     store.load Vosae.DownPaymentInvoice, {id: 1}
#     downPaymentInvoice = store.find Vosae.DownPaymentInvoice, 1
#     timelineEntry = store.find Vosae.DownPaymentInvoiceChangedStateTE, 1
#     ajaxHash.success $.extend({}, hashTimelineEntry, {
#       id: 1
#       previous_state: "DRAFT"
#       new_state: "REGISTERED"
#       down_payment_invoice_reference: "DOWNPAYMENTINVOICE 2013_12_04_001"
#       down_payment_invoice: "/api/v1/down_payment_invoice/1/"
#     })
  
#     # Test
#     expectAjaxType "GET"
#     expectAjaxURL "/timeline/1/"
#     expect(timelineEntry.get('previousState')).toEqual "DRAFT"
#     expect(timelineEntry.get('newState')).toEqual "REGISTERED"
#     expect(timelineEntry.get('downPaymentInvoiceReference')).toEqual "DOWNPAYMENTINVOICE 2013_12_04_001"
#     expect(timelineEntry.get('downPaymentInvoice')).toEqual downPaymentInvoice

#   it 'polymorph credit_note_changed_state_te', ->
#     # Setup
#     store.load Vosae.CreditNote, {id: 1}
#     creditNote = store.find Vosae.CreditNote, 1
#     timelineEntry = store.find Vosae.CreditNoteChangedStateTE, 1
#     ajaxHash.success $.extend({}, hashTimelineEntry, {
#       id: 1
#       previous_state: "DRAFT"
#       new_state: "REGISTERED"
#       credit_note_reference: "CREDITNOTE 2013_12_04_001"
#       credit_note: "/api/v1/credit_note/1/"
#     })

#     # Test
#     expectAjaxType "GET"
#     expectAjaxURL "/timeline/1/"
#     expect(timelineEntry.get('previousState')).toEqual "DRAFT"
#     expect(timelineEntry.get('newState')).toEqual "REGISTERED"
#     expect(timelineEntry.get('creditNoteReference')).toEqual "CREDITNOTE 2013_12_04_001"
#     expect(timelineEntry.get('creditNote')).toEqual creditNote

#   it 'polymorph quotation_make_invoice_te', ->
#     # Setup
#     store.load Vosae.Quotation, {id: 1}
#     store.load Vosae.Invoice, {id: 1}
#     quotation = store.find Vosae.Quotation, 1
#     invoice = store.find Vosae.Invoice, 1
#     timelineEntry = store.find Vosae.QuotationMakeInvoiceTE, 1
#     ajaxHash.success $.extend({}, hashTimelineEntry, {
#       id: 1
#       customer_display: "Vosae"
#       quotation_reference: "QUOTATION 2013_12_04_001"
#       quotation: "/api/v1/quotation/1/"
#       invoice_reference: "INVOICE 2013_12_04_001"
#       invoice_has_temporary_reference: true
#       invoice: "/api/v1/invoice/1/"
#     })

#     # Test
#     expectAjaxType "GET"
#     expectAjaxURL "/timeline/1/"
#     expect(timelineEntry.get('customerDisplay')).toEqual "Vosae"
#     expect(timelineEntry.get('quotationReference')).toEqual "QUOTATION 2013_12_04_001"
#     expect(timelineEntry.get('quotation')).toEqual quotation
#     expect(timelineEntry.get('invoiceReference')).toEqual "INVOICE 2013_12_04_001"
#     expect(timelineEntry.get('invoiceHasTemporaryReference')).toEqual true
#     expect(timelineEntry.get('invoice')).toEqual invoice

  
#   it 'polymorph quotation_make_down_payment_invoice_te', ->
#     # Setup
#     store.load Vosae.Quotation, {id: 1}
#     store.load Vosae.DownPaymentInvoice, {id: 1}
#     quotation = store.find Vosae.Quotation, 1
#     downPaymentInvoice = store.find Vosae.DownPaymentInvoice, 1
#     timelineEntry = store.find Vosae.QuotationMakeDownPaymentInvoiceTE, 1
#     ajaxHash.success $.extend({}, hashTimelineEntry, {
#       id: 1
#       quotation_reference: "QUOTATION 2013_12_04_001"
#       quotation: "/api/v1/quotation/1/"
#       down_payment_invoice: "/api/v1/down_payment_invoice/1/"
#     })

#     # Test
#     expectAjaxType "GET"
#     expectAjaxURL "/timeline/1/"
#     expect(timelineEntry.get('quotationReference')).toEqual "QUOTATION 2013_12_04_001"
#     expect(timelineEntry.get('quotation')).toEqual quotation
#     expect(timelineEntry.get('downPaymentInvoice')).toEqual downPaymentInvoice

#   it 'polymorph invoice_cancelled_te', ->
#     # Setup
#     store.load Vosae.Invoice, {id: 1}
#     store.load Vosae.CreditNote, {id: 1}
#     invoice = store.find Vosae.Invoice, 1
#     creditNote = store.find Vosae.CreditNote, 1
#     timelineEntry = store.find Vosae.InvoiceCancelledTE, 1
#     ajaxHash.success $.extend({}, hashTimelineEntry, {
#       id: 1
#       invoice_reference: "INVOICE 2013_12_04_001"
#       invoice: "/api/v1/invoice/1/"
#       credit_note: "/api/v1/credit_note/1/"
#     })

#     # Test
#     expectAjaxType "GET"
#     expectAjaxURL "/timeline/1/"
#     expect(timelineEntry.get('invoiceReference')).toEqual "INVOICE 2013_12_04_001"
#     expect(timelineEntry.get('invoice')).toEqual invoice
#     expect(timelineEntry.get('creditNote')).toEqual creditNote

#   it 'polymorph down_payment_invoice_cancelled_te', ->
#     # Setup
#     store.load Vosae.DownPaymentInvoice, {id: 1}
#     store.load Vosae.CreditNote, {id: 1}
#     downPaymentInvoice = store.find Vosae.DownPaymentInvoice, 1
#     creditNote = store.find Vosae.CreditNote, 1
#     timelineEntry = store.find Vosae.DownPaymentInvoiceCancelledTE, 1
#     ajaxHash.success $.extend({}, hashTimelineEntry, {
#       id: 1
#       down_payment_invoice_reference: "DOWNPAYMENTINVOICE 2013_12_04_001"
#       down_payment_invoice: "/api/v1/down_payment_invoice/1/"
#       credit_note: "/api/v1/credit_note/1/"
#     })

#     # Test
#     expectAjaxType "GET"
#     expectAjaxURL "/timeline/1/"
#     expect(timelineEntry.get('downPaymentInvoiceReference')).toEqual "DOWNPAYMENTINVOICE 2013_12_04_001"
#     expect(timelineEntry.get('downPaymentInvoice')).toEqual downPaymentInvoice
#     expect(timelineEntry.get('creditNote')).toEqual creditNote
# store = null

# describe 'Vosae.Notification', ->
#   hashNotification = 
#     read: false
#     sent_at: undefined

#   beforeEach ->
#     comp = getAdapterForTest(Vosae.Notification)
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

#   it 'finding all notification makes a GET to /notification/', ->
#     # Setup
#     notifications = store.find Vosae.Notification
    
#     # Test
#     enabledFlags notifications, ['isLoaded', 'isValid'], recordArrayFlags
#     expectAjaxURL "/notification/"
#     expectAjaxType "GET"

#     # Setup
#     ajaxHash.success(
#       meta: {}
#       objects: [
#         $.extend({}, hashNotification, {
#           id: 1
#           read: false
#         })
#       ]
#     )
#     notification = notifications.objectAt(0)

#     # Test
#     statesEqual notifications, 'loaded.saved'
#     stateEquals notification, 'loaded.saved'
#     enabledFlagsForArray notifications, ['isLoaded', 'isValid']
#     enabledFlags notification, ['isLoaded', 'isValid']
#     expect(notification).toEqual store.find(Vosae.Notification, 1)


#   it 'finding a notification by ID makes a GET to /notification/:id/', ->
#     # Setup
#     notification = store.find Vosae.Notification, 1
#     ajaxHash.success($.extend, {}, hashNotification, {id: 1, read: false})

#     # Test
#     expectAjaxType "GET"
#     expectAjaxURL "/notification/1/"
#     expect(notification).toEqual store.find(Vosae.Notification, 1)

#   it 'marking a notification as read makes a PUT to /notification/:id/mark_as_read/', ->
#     # Setup
#     store.load Vosae.Notification, {id: 1, read: false}
#     notification = store.find Vosae.Notification, 1
#     notification.markAsRead()

#     # Test
#     expectAjaxType "PUT"
#     expectAjaxURL "/notification/1/mark_as_read/"
#     expect(notification).toEqual store.find(Vosae.Notification, 1)
#     expect(notification.get('read')).toEqual true

#   it 'polymorph contact_saved_ne', ->
#     # Setup
#     store.load Vosae.Contact, {id: 1}
#     contact = store.find Vosae.Contact, 1
#     notification = store.find Vosae.ContactSavedNE, 1
#     ajaxHash.success $.extend({}, hashNotification, {
#       id: 1
#       resource_type: "contact_saved_ne"
#       contact_name: "Tom Dale"
#       contact: "/api/v1/contact/1/"
#     })

#     # Test
#     expectAjaxType "GET"
#     expectAjaxURL "/notification/1/"
#     expect(notification.get('module')).toEqual "contact"
#     expect(notification.get('contactName')).toEqual "Tom Dale"
#     expect(notification.get('contact')).toEqual contact


#   it 'polymorph organization_saved_ne', ->
#     # Setup
#     store.load Vosae.Organization, {id: 1}
#     organization = store.find Vosae.Organization, 1
#     notification = store.find Vosae.OrganizationSavedNE, 1
#     ajaxHash.success $.extend({}, hashNotification, {
#       id: 1
#       resource_type: "organization_saved_ne"
#       organization_name: "Naeka"
#       organization: "/api/v1/organization/1/"
#     })

#     # Test
#     expectAjaxType "GET"
#     expectAjaxURL "/notification/1/"
#     expect(notification.get('module')).toEqual "contact"
#     expect(notification.get('organizationName')).toEqual "Naeka"
#     expect(notification.get('organization')).toEqual organization

#   it 'polymorph quotation_saved_ne', ->
#     # Setup
#     store.load Vosae.Quotation, {id: 1}
#     quotation = store.find Vosae.Quotation, 1
#     notification = store.find Vosae.QuotationSavedNE, 1
#     ajaxHash.success $.extend({}, hashNotification, {
#       id: 1
#       resource_type: "quotation_saved_ne"
#       customer_display: "Vosae"
#       quotation_reference: "QUOTATION 2013_12_04_001"
#       quotation: "/api/v1/quotation/1/"
#     })

#     # Test
#     expectAjaxType "GET"
#     expectAjaxURL "/notification/1/"
#     expect(notification.get('module')).toEqual "invoicing"
#     expect(notification.get('customerDisplay')).toEqual "Vosae"
#     expect(notification.get('quotationReference')).toEqual "QUOTATION 2013_12_04_001"
#     expect(notification.get('quotation')).toEqual quotation

#   it 'polymorph invoice_saved_ne', ->
#     # Setup
#     store.load Vosae.Invoice, {id: 1}
#     invoice = store.find Vosae.Invoice, 1
#     notification = store.find Vosae.InvoiceSavedNE, 1
#     ajaxHash.success $.extend({}, hashNotification, {
#       id: 1
#       resource_type: "invoice_saved_ne"
#       customer_display: "Vosae"
#       invoice_reference: "INVOICE 2013_12_04_001"
#       invoice: "/api/v1/invoice/1/"
#     })

#     # Test
#     expectAjaxType "GET"
#     expectAjaxURL "/notification/1/"
#     expect(notification.get('module')).toEqual "invoicing"
#     expect(notification.get('customerDisplay')).toEqual "Vosae"
#     expect(notification.get('invoiceReference')).toEqual "INVOICE 2013_12_04_001"
#     expect(notification.get('invoice')).toEqual invoice

#   it 'polymorph down_payment_invoice_saved_ne', ->
#     # Setup
#     store.load Vosae.DownPaymentInvoice, {id: 1}
#     downPaymentInvoice = store.find Vosae.DownPaymentInvoice, 1
#     notification = store.find Vosae.DownPaymentInvoiceSavedNE, 1
#     ajaxHash.success $.extend({}, hashNotification, {
#       id: 1
#       resource_type: "down_payment_invoice_saved_ne"
#       customer_display: "Vosae"
#       down_payment_invoice_reference: "DOWNPAYMENTINVOICE 2013_12_04_001"
#       down_payment_invoice: "/api/v1/down_payment_invoice/1/"
#     })

#     # Test
#     expectAjaxType "GET"
#     expectAjaxURL "/notification/1/"
#     expect(notification.get('module')).toEqual "invoicing"
#     expect(notification.get('customerDisplay')).toEqual "Vosae"
#     expect(notification.get('downPaymentInvoiceReference')).toEqual "DOWNPAYMENTINVOICE 2013_12_04_001"
#     expect(notification.get('downPaymentInvoice')).toEqual downPaymentInvoice

#   it 'polymorph credit_note_saved_ne', ->
#     # Setup
#     store.load Vosae.CreditNote, {id: 1}
#     creditNote = store.find Vosae.CreditNote, 1
#     notification = store.find Vosae.CreditNoteSavedNE, 1
#     ajaxHash.success $.extend({}, hashNotification, {
#       id: 1
#       resource_type: "credit_note_saved_ne"
#       customer_display: "Vosae"
#       credit_note_reference: "CREDITNOTE 2013_12_04_001"
#       credit_note: "/api/v1/credit_note/1/"
#     })

#     # Test
#     expectAjaxType "GET"
#     expectAjaxURL "/notification/1/"
#     expect(notification.get('module')).toEqual "invoicing"
#     expect(notification.get('customerDisplay')).toEqual "Vosae"
#     expect(notification.get('creditNoteReference')).toEqual "CREDITNOTE 2013_12_04_001"
#     expect(notification.get('creditNote')).toEqual creditNote

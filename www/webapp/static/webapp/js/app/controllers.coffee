Em.ObjectController.reopen
  needs: ['application']

Em.ArrayController.reopen
  needs: ['application']

# Custom array controller
Vosae.ArrayController = Em.ArrayController.extend
  meta: null

  getModel :->
    switch @constructor.toString()
      when Vosae.NotificationsController.toString() then Vosae.Notification
      when Vosae.ContactsShowController.toString() then Vosae.Contact
      when Vosae.OrganizationsShowController.toString() then Vosae.Organization
      when Vosae.InvoicesShowController.toString() then Vosae.Invoice
      when Vosae.QuotationsShowController.toString() then Vosae.Quotation
      when Vosae.ItemsShowController.toString() then Vosae.Item
      when Vosae.PurchaseOrdersShowController.toString() then Vosae.PurchaseOrder

  init: ->
    @_super()

    switch @constructor.toString()
      when Vosae.NotificationsController.toString() then @set 'meta', Vosae.metaForNotification
      when Vosae.ContactsShowController.toString() then @set 'meta', Vosae.metaForContact
      when Vosae.OrganizationsShowController.toString() then @set 'meta', Vosae.metaForOrganization
      when Vosae.InvoicesShowController.toString() then @set 'meta', Vosae.metaForInvoice
      when Vosae.QuotationsShowController.toString() then @set 'meta', Vosae.metaForQuotation
      when Vosae.ItemsShowController.toString() then @set 'meta', Vosae.metaForItem
      when Vosae.PurchaseOrdersShowController.toString() then @set 'meta', Vosae.metaForPurchaseOrder

    # Check if model hasn't be fetched yet
    if @get('meta') and !@get('meta.modelHasBeenFetched')
      @send("getNextPagination")

  actions:
    # Pagination retrieve next model objects
    getNextPagination: ->
      pagination = null

      if @get('meta') and !@get('meta.loading')
        if @get('meta.next') or !@get('meta.modelHasBeenFetched')
          offset = if @get('meta.offset')? then @get('meta.offset') + @get('meta.limit') else 0
          pagination =
            data: @getModel().find(offset: offset)
            offset: @get('meta.offset')
            limit: @get('meta.limit')
            lastLength: @getModel().all().get('length')
          @set 'meta.loading', true

      return pagination

# Import controllers
require 'controllers/core/application'
require 'controllers/core/dashboardShow'
require 'controllers/core/search'
require 'controllers/core/notifications'
require 'controllers/core/tenantsShow'
require 'controllers/core/tenantsAdd'

require 'controllers/settings/settingsOrganization'
require 'controllers/settings/settingsShowUsers'
require 'controllers/settings/settingsShowGroups'
require 'controllers/settings/settingsShowTaxes'
require 'controllers/settings/settingsEditUser'
require 'controllers/settings/settingsEditGroup'
require 'controllers/settings/settingsEditTax'
require 'controllers/settings/settingsInvoicingGeneral'
require 'controllers/settings/settingsNumbering'
require 'controllers/settings/settingsApiKeys'
require 'controllers/settings/settingsReport'
require 'controllers/settings/settingsDataLiberation'

require 'controllers/realtime/realtime'

require 'controllers/contacts/entity'
require 'controllers/contacts/entities'
require 'controllers/contacts/organizationsShow'
require 'controllers/contacts/contactsShow'
require 'controllers/contacts/contactEdit'
require 'controllers/contacts/organizationEdit'
require 'controllers/contacts/contactShow'
require 'controllers/contacts/organizationShow'

require 'controllers/invoicing/invoicingDashboard'
require 'controllers/invoicing/invoicingFyFlowStatistics'
require 'controllers/invoicing/invoiceBase'
require 'controllers/invoicing/invoicesBase'
require 'controllers/invoicing/quotationShow'
require 'controllers/invoicing/invoiceShow'
require 'controllers/invoicing/quotationEdit'
require 'controllers/invoicing/invoiceEdit'
require 'controllers/invoicing/quotationsShow'
require 'controllers/invoicing/invoicesShow'
require 'controllers/invoicing/itemsShow'
require 'controllers/invoicing/itemShow'
require 'controllers/invoicing/itemEdit'
require 'controllers/invoicing/creditNoteShow'
require 'controllers/invoicing/purchaseOrderShow'
require 'controllers/invoicing/purchaseOrdersShow'
require 'controllers/invoicing/purchaseOrderEdit'

require 'controllers/organizer/calendarListsShow'
require 'controllers/organizer/calendarListShow'
require 'controllers/organizer/calendarListEdit'
require 'controllers/organizer/vosaeEventShow'
require 'controllers/organizer/vosaeEventEdit'
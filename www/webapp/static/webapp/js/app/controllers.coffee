Em.ObjectController.reopen
  needs: ['application']

Em.ArrayController.reopen
  needs: ['application']

# Custom array controller
Vosae.ArrayController = Em.ArrayController.extend
  meta: null

  getModel :->
    switch @constructor
      when Vosae.NotificationsController then Vosae.Notification
      when Vosae.ContactsShowController then Vosae.Contact
      when Vosae.OrganizationsShowController then Vosae.Organization
      when Vosae.InvoicesShowController then Vosae.Invoice
      when Vosae.QuotationsShowController then Vosae.Quotation
      when Vosae.ItemsShowController then Vosae.Item
      when Vosae.PurchaseOrdersShowController then Vosae.PurchaseOrder

  init: ->
    @_super()

    switch @constructor
      when Vosae.NotificationsController then @set 'meta', Vosae.metaForNotification
      when Vosae.ContactsShowController then @set 'meta', Vosae.metaForContact
      when Vosae.OrganizationsShowController then @set 'meta', Vosae.metaForOrganization
      when Vosae.InvoicesShowController then @set 'meta', Vosae.metaForInvoice
      when Vosae.QuotationsShowController then @set 'meta', Vosae.metaForQuotation
      when Vosae.ItemsShowController then @set 'meta', Vosae.metaForItem
      when Vosae.PurchaseOrdersShowController then @set 'meta', Vosae.metaForPurchaseOrder

    # Check if model hasn't be fetched yet
    if @get('meta') and !@get('meta.modelHasBeenFetched')
      @getNextPagination()

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
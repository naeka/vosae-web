# Imports routes
require 'routes/router'
require 'routes/route'

require 'routes/application'

require 'routes/core/dashboardIndex'

require 'routes/tenants/tenant'
require 'routes/tenants/tenantIndex'
require 'routes/tenants/tenantsShow'
require 'routes/tenants/tenantsAdd'

require 'routes/contacts/contactsShow'
require 'routes/contacts/contactsAdd'
require 'routes/contacts/contactEdit'
require 'routes/contacts/contactShow'
require 'routes/contacts/organizationsShow'
require 'routes/contacts/organizationsAdd'
require 'routes/contacts/organizationEdit'
require 'routes/contacts/organizationShow'
require 'routes/contacts/organizationAddContact'

require 'routes/organizer/root'
require 'routes/organizer/calendarListsShow'
require 'routes/organizer/calendarListsAdd'
require 'routes/organizer/calendarListShow'
require 'routes/organizer/calendarListEdit'
require 'routes/organizer/vosaeEventShow'
require 'routes/organizer/vosaeEventEdit'

require 'routes/invoicing/root'
require 'routes/invoicing/invoiceEdit'
require 'routes/invoicing/invoicesAdd'
require 'routes/invoicing/invoiceShow'
require 'routes/invoicing/invoicesShow'
require 'routes/invoicing/invoicingDashboard'
require 'routes/invoicing/quotationEdit'
require 'routes/invoicing/quotationsAdd'
require 'routes/invoicing/quotationShow'
require 'routes/invoicing/quotationsShow'
require 'routes/invoicing/itemsShow'
require 'routes/invoicing/itemsAdd'
require 'routes/invoicing/itemShow'
require 'routes/invoicing/itemEdit'
require 'routes/invoicing/creditNoteShow'
require 'routes/invoicing/purchaseOrderShow'
require 'routes/invoicing/purchaseOrderEdit'
require 'routes/invoicing/purchaseOrdersShow'
require 'routes/invoicing/purchaseOrdersAdd'

require 'routes/settings/root'
require 'routes/settings/settingsAddGroup'
require 'routes/settings/settingsAddTax'
require 'routes/settings/settingsAddUser'
require 'routes/settings/settingsApiKeys'
require 'routes/settings/settingsApplication'
require 'routes/settings/settingsInvoicingGeneral'
require 'routes/settings/settingsNumbering'
require 'routes/settings/settingsEditGroup'
require 'routes/settings/settingsEditTax'
require 'routes/settings/settingsEditUser'
require 'routes/settings/settingsOrganization'
require 'routes/settings/settingsShowGroups'
require 'routes/settings/settingsShowTaxes'
require 'routes/settings/settingsShowUsers'
require 'routes/settings/settingsReport'
Vosae.Router.reopen
  location: 'history'
  rootURL: '/'

Vosae.Router.map ->
  @route 'index', path: '/'
  @route 'forbidden', path: '/403'
  @route 'internalServerError', path: '/500'  

  @resource 'tenants', path: '/tenants', ->
    @route 'show', path: '/'
    @route 'add', path: '/add', ->

  @resource 'tenant', path: '/:tenant_slug', ->
    @route 'index', path: '/'
    @resource 'dashboard', path: '/timeline', ->  
      @route 'show', path: '/'

    @resource 'contacts', path: '/contacts', ->
      @route 'show', path: '/'
      @route 'add'
    @resource 'contact', path: '/contacts/:contact_id', ->
      @route 'show', path: '/'
      @route 'edit'
    @resource 'organizations', path: '/contacts/organizations', ->
      @route 'show', path: '/'
      @route 'add'
    @resource 'organization', path: '/contacts/organization/:organization_id', ->
      @route 'show', path: '/'
      @route 'edit'
      @route 'addContact', path: '/contact/add'

    @resource 'calendarLists', path: '/organizer', ->
      @route 'show', path: '/'
      @route 'add'
    @resource 'calendarList', path: '/organizer/calendar/:calendar_list_id', ->
      @route 'show', path: '/'
      @route 'edit'
    @resource 'vosaeEvent', path: '/organizer/event/:vosae_event_id', ->
      @route 'show', path: '/'
      @route 'edit'

    @resource 'invoicing', path: '/invoicing', ->
      @route 'dashboard', path: '/'
    @resource 'quotations', path: '/invoicing/quotations', ->
      @route 'show', path: '/'  
      @route 'add'
    @resource 'quotation', path: '/invoicing/quotation/:quotation_id', ->
      @route 'show', path: '/'
      @route 'edit'
    @resource 'invoices', path: '/invoicing/invoices', ->
      @route 'show', path: '/'
      @route 'add'
    @resource 'invoice', path: '/invoicing/invoice/:invoice_id', ->
      @route 'show', path: '/'
      @route 'edit'
    @resource 'items', path: '/invoicing/items', ->
      @route 'show', path: '/'
      @route 'add'
    @resource 'item', path: '/invoicing/item/:item_id', ->
      @route 'show', path: '/'
      @route 'edit'
    @resource 'creditNote', path: '/invoicing/credit-note/:credit_note_id', ->
      @route 'show', path: '/'
    @resource 'purchaseOrders', path: '/invoicing/purchase-orders', ->
      @route 'show', path: '/'
      @route 'add'
    @resource 'purchaseOrder', path: '/invoicing/purchase-order/:purchase_order_id', ->
      @route 'show', path: '/'
      @route 'edit'

    @resource 'settings', path: '/settings', ->
      @route 'application'
      @route 'apiKeys', path: '/api_keys'
      @route 'organization'
      @route 'showUsers', path: '/users'
      @route 'addUser', path: '/users/add'
      @route 'editUser', path: '/users/:user_id'
      @route 'showGroups', path: '/groups'
      @route 'addGroup', path: '/groups/add'
      @route 'editGroup', path: '/groups/:group_id'
      @route 'showTaxes', path: '/taxes'
      @route 'addTax', path: '/taxes/add'
      @route 'editTax', path: '/taxes/:tax_id'
      @route 'invoicingGeneral', path: '/invoicing/general'
      @route 'numbering', path: '/numbering'
      @route 'report', path: '/report'
  
  @route 'notFound', path: '*:' 

Ember.Route.reopen
  serialize: (model, params) ->
    if params.length isnt 1
      return

    name = params[0]
    object = {}

    if /_id$/.test(name)
      object[name] = Ember.get(model, "id")
    else if /_slug$/.test(name)
      object[name] = Ember.get(model, "slug")
    else
      object[name] = model
    return object

Vosae.SelectedTenantRoute = Ember.Route.extend
  redirect: ->
    tenant = @get('session.tenant')
    unless tenant and tenant.get('slug') 
      this.transitionTo 'tenants.show'

Vosae.AppDashboardRoute = Vosae.SelectedTenantRoute.extend
  setupController: ->
    Vosae.lookup('controller:application').set('currentRoute', 'dashboard')

Vosae.AppContactsRoute = Vosae.SelectedTenantRoute.extend
  setupController: ->
    Vosae.lookup('controller:application').set('currentRoute', 'contacts')
    Vosae.lookup('controller:contactsShow') # Hack for contacts.totalCount

Vosae.AppOrganizerRoute = Vosae.SelectedTenantRoute.extend
  setupController: ->
    Vosae.lookup('controller:application').set('currentRoute', 'organizer')

Vosae.AppInvoicingRoute = Vosae.SelectedTenantRoute.extend
  setupController: ->
    Vosae.lookup('controller:application').set('currentRoute', 'invoicing')

Vosae.AppSettingsRoute = Vosae.SelectedTenantRoute.extend()

Vosae.AppTenantsRoute = Ember.Route.extend()

Vosae.InternalServerErrorRoute = Ember.Route.extend()

Vosae.ForbiddenRoute = Ember.Route.extend()

Vosae.NotFoundRoute = Ember.Route.extend()

Vosae.IndexRoute = Ember.Route.extend
  redirect: ->
    tenant = @get('session.tenant')
    if tenant and tenant.get('slug')
      this.transitionTo 'dashboard.show', tenant
    else
      this.transitionTo 'tenants.show'

# Import routes
require 'routes/core/root'
require 'routes/core/dashboardShow'

require 'routes/tenants/root'
require 'routes/tenants/tenantsShow'
require 'routes/tenants/tenantsAdd'
require 'routes/tenants/tenantIndex'

require 'routes/contacts/root'
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

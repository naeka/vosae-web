###
  All routes for the application

  @method map
  @namespace Vosae
  @module Vosae
###

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
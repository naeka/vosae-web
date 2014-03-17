###
  The main controller of the application

  @class ApplicationController
  @extends Ember.Controller
  @namespace Vosae
  @module Vosae
###

Vosae.ApplicationController = Ember.Controller.extend
  # Routes that belongs to app contacts
  appContactsPaths: [
    'tenant.organizations'
    'tenant.contacts'
    'tenant.organization'
    'tenant.contact'
  ]

  # Routes that belongs to app organizer
  appOrganizerPaths: [
    'tenant.calendarLists'
    'tenant.calendarList'
    'tenant.vosaeEvent'
  ]

  # Routes that belongs to app invoicing
  appInvoicingPaths: [
    'invoicing'
    'quotations'
    'quotation'
    'invoices'
    'invoice'
    'items'
    'item'
    'creditNote'
    'purchaseOrders'
    'purchaseOrder'
  ]

  isDashboard: (->
    @get('currentPath').startsWith 'tenant.dashboard.'
  ).property('currentPath')

  isContacts: (->
    currentPath = @get('currentPath')
    @appContactsPaths.some (path) ->
      currentPath.startsWith path
  ).property('currentPath')

  isOrganizer: (->
    currentPath = @get('currentPath')
    @appOrganizerPaths.some (path) ->
      currentPath.startsWith path
  ).property('currentPath')

  isInvoicing: (->
    currentPath = @get('currentPath')
    @appInvoicingPaths.some (path) ->
      currentPath.startsWith path
  ).property('currentPath')

  isTenantsShow: (->
    @get('currentPath').startsWith 'tenants.show'
  ).property('currentPath')

  isTenantsAdd: (->
    @get('currentPath').startsWith 'tenants.add'
  ).property('currentPath')
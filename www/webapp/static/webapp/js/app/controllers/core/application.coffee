###
  The main controller of the application

  @class ApplicationController
  @extends Ember.Controller
  @namespace Vosae
  @module Vosae
###

Vosae.ApplicationController = Ember.Controller.extend

  isDashboard: (->
    @get('currentPath').startsWith 'tenant.dashboard.'
  ).property('currentPath')

  isContacts: (->
    @get('currentPath').startsWith 'tenant.contacts.'
  ).property('currentPath')

  isOrganizer: (->
    @get('currentPath').startsWith 'tenant.organizer.'
  ).property('currentPath')

  isInvoicing: (->
    @get('currentPath').startsWith 'tenant.invoicing.'
  ).property('currentPath')

  isTenantsShow: (->
    @get('currentPath').startsWith 'tenants.show'
  ).property('currentPath')

  isTenantsAdd: (->
    @get('currentPath').startsWith 'tenants.add'
  ).property('currentPath')
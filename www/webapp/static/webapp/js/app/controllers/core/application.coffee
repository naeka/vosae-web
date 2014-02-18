###
  The main controller of the application

  @class ApplicationController
  @extends Ember.Controller
  @namespace Vosae
  @module Vosae
###

Vosae.ApplicationController = Ember.Controller.extend
  needs: ['notifications', 'search', 'realtime', 'tenantsShow'],
  
  isDashboard: (->
    @get('currentRoute') == 'dashboard'
  ).property 'currentRoute'

  isContacts: (->
    @get('currentRoute') == 'contacts'
  ).property 'currentRoute'

  isOrganizer: (->
    @get('currentRoute') == 'organizer'
  ).property 'currentRoute'

  isInvoicing: (->
    @get('currentRoute') == 'invoicing'
  ).property 'currentRoute'

  isTenantsShow: (->
    @get('currentRoute') == 'tenants.show'
  ).property 'currentRoute'

  isTenantsAdd: (->
    @get('currentRoute') == 'tenants.add'
  ).property 'currentRoute'
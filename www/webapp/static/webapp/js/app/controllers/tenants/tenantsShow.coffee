###
  Custom controller for a collection of `Vosae.Tenant` records.

  @class TenantsShowController
  @extends Em.ArrayController
  @namespace Vosae
  @module Vosae
###

Vosae.TenantsShowController = Em.ArrayController.extend
  needs: ['realtime']

  actions:
    # Redirection to the tenant root with a complete reload of the application
    redirectToTenantRoot: (tenant) ->
      url = window.location.origin + '/' + tenant.get('slug')
      $(location).attr 'href', url

    # Set the tenant as the current app tenant
    setAsCurrentTenant: (tenant) ->
      if tenant
        Vosae.Utilities.showLoader()
        Vosae.Utilities.setPageTitle tenant.get('name')
        @get('session').set 'tenant', tenant
        @putTenantInAjaxHeaders tenant
        @getTenantDependencies()

  # Returns an array with all tenants excluded the current one
  otherTenants: (->
    array = []
    if @get('content') and @get('content.length')
      @get('content').filter (tenant) =>
        unless tenant.get('slug') is @get('session.tenant').get('slug')
          array.pushObject tenant
    array
  ).property('content', 'content.length')

  # Update the ajax headers with the tenant slug
  putTenantInAjaxHeaders: (tenant) ->
    $.ajaxSetup
      headers: 
        'X-Tenant': tenant.get 'slug'
   
  # Get each dependencies for the tenant
  getTenantDependencies: ->
    currentUser = @store.findQuery('user', email: Vosae.Config.AUTH_USER).then (user) =>
      @set 'session.user', user.get('firstObject')
      Vosae.Config.PUSHER_USER_CHANNEL = "private-user-#{@get('session.user.id')}"
      @get "controllers.realtime"

    tenantSettings = @store.find('tenantSettings').then (tenantSettings) =>
      @set 'session.tenantSettings', tenantSettings.get('firstObject')

    groups = @store.findAll 'group'
    taxes = @store.findAll 'tax'
    users = @store.findAll 'user'

    Ember.RSVP.all([currentUser, tenantSettings, groups, taxes, users]).then =>
      nextUrl = @get 'session.nextUrl'
      if nextUrl and nextUrl.startsWith("/#{@get('session.tenant.slug')}")
        console.log 'here 1'
        router = Vosae.lookup 'router:main'
        router.router.updateURL nextUrl
        router.handleURL nextUrl
      else
        console.log 'here 2'
        @transitionToRoute 'dashboard.show', @get('session.tenant')

      # Hide the loader
      Ember.run.later (=>
        Vosae.Utilities.hideLoader()
      ), 500
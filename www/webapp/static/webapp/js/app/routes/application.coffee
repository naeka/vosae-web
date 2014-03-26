###
  The top level route. This route is entered when Vosae first boots up
  It will be in charge to fetch all dependencies we need such as
  `currencies` and `tenants` before the application is used by users.
  

  @class ApplicationRoute
  @extends Ember.Route
  @namespace Vosae
  @module Vosae
###

Vosae.ApplicationRoute = Ember.Route.extend
  model: ->
    # Fetch dependencies
    tenants = @store.findAll 'tenant'
    currencies = @store.findAll 'currency'

    Ember.RSVP.all [tenants, currencies]

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
        @replaceWith nextUrl
      else
        @transitionTo 'dashboard', @get('session.tenant')

      # Hide the loader
      Ember.run.later (=>
        Vosae.Utilities.hideLoader()
      ), 1500

  actions:
    # Redirection to the tenant root with a complete reload of the application
    redirectToTenantRoot: (tenant) ->
      url = window.location.origin + '/' + tenant.get('slug')
      $(location).attr 'href', url

    # Set the tenant as the current app tenant
    setAsCurrentTenant: (tenant) ->
      Vosae.Utilities.showLoader()
      Vosae.Utilities.setPageTitle tenant.get('name')
      @get('session').set 'tenant', tenant
      @putTenantInAjaxHeaders tenant
      @getTenantDependencies()
Vosae.TenantsShowRoute = Ember.Route.extend
  model: ->
    # Get all tenants
    @store.all 'tenant'

  afterModel: (tenants, transition) ->
    # Without tenant, user must create one
    if tenants.length is 0
      @transitionTo 'tenants.add'

    # User has only one tenant
    else if tenants.length == 1
      tenant = tenants.get 'firstObject'
      transition.send "setAsCurrentTenant", tenant
    
    # User has several tenants
    else 
      # If there is a tenant slug in URL like `/my-company/contact/1/`
      # we consider user want to use the tenant with slug `my-company`
      preselectedTenant = @get 'session.preselectedTenant'
      if preselectedTenant
        tenant = tenants.findProperty 'slug', preselectedTenant
        transition.send "setAsCurrentTenant", tenant if tenant

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
        @transitionTo 'dashboard.show', @get('session.tenant')

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
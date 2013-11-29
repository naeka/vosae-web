Vosae.TenantsShowController = Em.ArrayController.extend
  needs: ['realtime']
  currentUserIsLoaded: false
  tenantSettingsAreLoaded: false
  taxesAreLoaded: false
  usersAreLoaded: false  
  groupsAreLoaded: false

  actions:
    # Redirection to the tenant root with a complete reload of the application
    redirectToTenantRoot: (tenant) ->
      url = window.location.origin + '/' + tenant.get('slug')
      $(location).attr 'href', url

    # Set the tenant as the current app tenant
    setAsCurrentTenant: (tenant) ->
      if tenant
        @get('namespace').showLoader()
        @get('session').set 'tenant', tenant
        @get('namespace').setPageTitle tenant.get('name')
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

  # Check dependencies until loaded and then redirect the user
  checkTenantDependencies: ->
    tenantDepenciesAreLoaded = true
    depencies = [
      'currentUserIsLoaded',
      'tenantSettingsAreLoaded',
      'taxesAreLoaded',
      'usersAreLoaded',
      'groupsAreLoaded',
    ]

    depencies.forEach (dep) =>
      unless @get(dep)
        tenantDepenciesAreLoaded = false

    if tenantDepenciesAreLoaded      
      nextUrl = @get 'session.nextUrl'
      if nextUrl and nextUrl.startsWith("/#{@get('session.tenant.slug')}")
        router = Vosae.lookup 'router:main'
        router.router.updateURL nextUrl
        router.handleURL nextUrl
      else
        @transitionToRoute 'dashboard.show', @get('session.tenant')

      Ember.run.later (=>
        @get('namespace').hideLoader()
      ), 500

  # Get each dependencies for the tenant
  getTenantDependencies: ->
    # Current Vosae user
    user = Vosae.User.find email: AUTH_USER
    user.one "didLoad", @, ->
      @set 'session.user', user.get('firstObject')
      window.PUSHER_USER_CHANNEL = "private-user-#{@get('session.user.id')}"
      @get "controllers.realtime"
      @set "currentUserIsLoaded", true
      @checkTenantDependencies()

    # Fetch tenant settings
    @set 'session.tenantSettings', Vosae.TenantSettings.find(1)
    @get('session.tenantSettings').one "didLoad", @, ->
      @set "tenantSettingsAreLoaded", true
      @checkTenantDependencies()

    # Fetch Groups
    groups = Vosae.Group.find({})
    groups.one "didLoad", @, ->
      @set "groupsAreLoaded", true
      @checkTenantDependencies()

    # Fetch Taxes
    taxes = Vosae.Tax.find({})
    taxes.one "didLoad", @, ->
      @set "taxesAreLoaded", true
      @checkTenantDependencies()

    # Fetch Users
    users = Vosae.User.find({})
    users.one "didLoad", @, ->
      @set "usersAreLoaded", true
      @checkTenantDependencies()
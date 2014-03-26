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
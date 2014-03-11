Vosae.TenantsShowRoute = Ember.Route.extend
  model: ->
    # Get all tenants
    @store.all 'tenant'

  afterModel: (tenants, transition) ->
    # Without tenant, user must create one
    if tenants.length is 0
      @transitionTo 'tenants.add'

  setupController: (controller, tenants) ->
    @controllerFor('application').set 'currentRoute', 'tenants.show'

    # User has only one tenant
    if tenants.length == 1
      tenant = tenants.get 'firstObject'
      controller.send "setAsCurrentTenant", tenant
    # User has several tenants
    else 
      # If there is a tenant slug in URL like `/my-company/contact/1/`
      # we consider user want to use the tenant with slug `my-company`
      preselectedTenant = @get 'session.preselectedTenant'
      if preselectedTenant
        tenant = tenants.findProperty 'slug', preselectedTenant
        controller.send "setAsCurrentTenant", tenant if tenant
    
    # Otherwise user will have to select a tenant in list
    controller.set "content", tenants

  renderTemplate: ->
    @render
      into: 'tenants'
Vosae.TenantsShowRoute = Ember.Route.extend
  model: ->
    Vosae.Tenant.all()

  redirect: ->
    tenants = Vosae.Tenant.all()
    if tenants.get('length') == 0
      @transitionTo 'tenants.add'

  setupController: (controller, model) ->
    Vosae.lookup('controller:application').set 'currentRoute', 'tenants.show'

    nbrTenants = model.get 'length'
    if nbrTenants == 1
      tenant = model.get 'firstObject'
      controller.send "setAsCurrentTenant", tenant
    else
      if @get 'session.preselectedTenant'
        tenant = model.findProperty 'slug', @get('session.preselectedTenant')
        controller.send("setAsCurrentTenant", tenant) if tenant
    controller.set 'content', model

  renderTemplate: ->
    @render
      into: 'tenants'
Ember.Route.reopen
  serialize: (model, params) ->
    if params.length isnt 1
      return

    name = params[0]
    object = {}

    if /_id$/.test(name)
      object[name] = Ember.get(model, "id")
    else if /_slug$/.test(name)
      object[name] = Ember.get(model, "slug")
    else
      object[name] = model

    return object


Vosae.InternalServerErrorRoute = Ember.Route.extend()

Vosae.ForbiddenRoute = Ember.Route.extend()

Vosae.NotFoundRoute = Ember.Route.extend()

Vosae.IndexRoute = Ember.Route.extend
  redirect: ->
    tenant = @get('session.tenant')
    if tenant and tenant.get('slug')
      this.transitionTo 'dashboard', tenant
    else
      this.transitionTo 'tenants.show'
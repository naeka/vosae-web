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


###
  The parent route for all discovery routes. Handles the logic for showing
  the loading spinners.

  @class DiscoveryRoute
  @extends Discourse.Route
  @namespace Discourse
  @module Discourse
###

Vosae.SelectedTenantRoute = Ember.Route.extend
  redirect: ->
    tenant = @get('session.tenant')
    unless tenant and tenant.get('slug') 
      this.transitionTo 'tenants.show'

Vosae.InternalServerErrorRoute = Ember.Route.extend()

Vosae.ForbiddenRoute = Ember.Route.extend()

Vosae.NotFoundRoute = Ember.Route.extend()

Vosae.IndexRoute = Ember.Route.extend
  redirect: ->
    tenant = @get('session.tenant')
    if tenant and tenant.get('slug')
      this.transitionTo 'dashboard.show', tenant
    else
      this.transitionTo 'tenants.show'
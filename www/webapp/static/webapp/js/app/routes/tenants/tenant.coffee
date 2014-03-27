###
  The parent of all routes that require a tenant. If there's no
  tenant in the current session user will be redirected to a page
  which list all the user's tenants.

  @class TenantRoute
  @extends Ember.Route
  @namespace Vosae
  @module Vosae
###

Vosae.TenantRoute = Ember.Route.extend
  redirect: ->
    tenant = @get('session.tenant')
    unless tenant and tenant.get('slug') 
      this.transitionTo 'tenants.show'
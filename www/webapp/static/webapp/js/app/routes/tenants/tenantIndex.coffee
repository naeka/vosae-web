Vosae.TenantIndexRoute = Ember.Route.extend
  redirect: ->
    @transitionTo 'dashboard', @get('session.tenant')
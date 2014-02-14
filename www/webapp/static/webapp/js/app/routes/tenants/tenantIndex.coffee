Vosae.TenantIndexRoute = Ember.Route.extend
  redirect: ->
    @transitionTo 'dashboard.show', @get('session.tenant')
Vosae.DashboardRoute = Vosae.SelectedTenantRoute.extend
  setupController: ->
    @controllerFor('application').set 'currentRoute', 'dashboard'
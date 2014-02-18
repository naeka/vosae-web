Vosae.AppDashboardRoute = Vosae.SelectedTenantRoute.extend
  setupController: ->
    Vosae.lookup('controller:application').set('currentRoute', 'dashboard')

Vosae.DashboardRoute = Vosae.AppDashboardRoute.extend()
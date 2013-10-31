Vosae.DashboardRoute = Vosae.AppDashboardRoute.extend
  renderTemplate: ->
    @render
      into: 'application'

Vosae.TenantsRoute = Vosae.AppTenantsRoute.extend
  renderTemplate: ->
    @render
      into: 'application'
      outlet: 'outletTenants'
Vosae.TenantsRoute = Vosae.AppTenantsRoute.extend
  renderTemplate: ->
    @render
      into: 'application'
      outlet: 'outletTenants'
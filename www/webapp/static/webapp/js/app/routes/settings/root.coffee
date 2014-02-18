Vosae.AppSettingsRoute = Vosae.SelectedTenantRoute.extend()

Vosae.SettingsRoute = Vosae.AppSettingsRoute.extend
  renderTemplate: ->
    @render
      into: 'application'
      outlet: 'outletSettings'
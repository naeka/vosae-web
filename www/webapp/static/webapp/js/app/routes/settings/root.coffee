Vosae.SettingsRoute = Vosae.AppSettingsRoute.extend
  renderTemplate: ->
    @render
      into: 'application'
      outlet: 'outletSettings'
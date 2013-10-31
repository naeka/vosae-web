Vosae.SettingsApplicationRoute = Ember.Route.extend
  renderTemplate: ->
    @render 'settings.application',
      into: 'settings'
      outlet: 'content'
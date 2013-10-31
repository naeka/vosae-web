Vosae.DashboardShowRoute = Ember.Route.extend
  model: ->
    Vosae.Timeline.all()
  
  renderTemplate: ->
    @_super()
    @render 'dashboard.show.settings',
      into: 'application'
      outlet: 'outletPageSettings'
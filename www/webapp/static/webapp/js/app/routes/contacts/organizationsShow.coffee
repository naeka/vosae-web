Vosae.OrganizationsShowRoute = Ember.Route.extend
  model: ->
    Vosae.Organization.all()

  renderTemplate: ->
    @_super()
    @render 'organizations.show.settings',
      into: 'application'
      outlet: 'outletPageSettings'

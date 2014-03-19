Vosae.OrganizationEditRoute = Ember.Route.extend
  model: ->
    @modelFor("organization")  
  
  renderTemplate: ->
    @_super()
    @render 'organization.edit.settings',
      into: 'tenant'
      outlet: 'outletPageSettings'

  deactivate: ->
    model = @controller.get "content"
    model.rollback() if model
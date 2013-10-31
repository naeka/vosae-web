Vosae.OrganizationEditRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.set 'content', @modelFor("organization")
  
  deactivate: ->
    organization = @controller.get 'content'
    if organization.get 'transaction'
      organization.get("transaction").rollback()
  
  renderTemplate: ->
    @_super()
    @render 'organization.edit.settings',
      into: 'application'
      outlet: 'outletPageSettings'
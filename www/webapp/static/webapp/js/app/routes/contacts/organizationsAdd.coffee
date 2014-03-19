Vosae.OrganizationsAddRoute = Ember.Route.extend
  controllerName: "organizationEdit"

  model: ->
    @store.createRecord "organization"

  deactivate: ->
    model = @controller.get "content"
    model.rollback() if model 
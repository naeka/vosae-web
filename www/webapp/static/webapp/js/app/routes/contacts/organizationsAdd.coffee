Vosae.OrganizationsAddRoute = Ember.Route.extend
  init: ->
    @_super()
    @get('container').register 'controller:organizations.add', Vosae.OrganizationEditController

  model: ->
    Vosae.Organization.createRecord()

  deactivate: ->
    organization = @controller.get 'content'
    if organization.get 'transaction'
      organization.get("transaction").rollback()
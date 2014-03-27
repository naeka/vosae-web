Vosae.ContactEditRoute = Ember.Route.extend
  model: ->
    @modelFor("contact")

  renderTemplate: ->
    @_super()
    @render 'contact.edit.settings',
      into: 'tenant'
      outlet: 'outletPageSettings'

  deactivate: ->
    model = @controller.get "content"
    model.rollback() if model
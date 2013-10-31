Vosae.ContactEditRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.set 'content', @modelFor("contact")
    controller.set 'organizations', Vosae.Organization.find()

  deactivate: ->
    contact = @controller.get 'content'
    if contact.get 'transaction'
      contact.get("transaction").rollback()

  renderTemplate: ->
    @_super()
    @render 'contact.edit.settings',
      into: 'application'
      outlet: 'outletPageSettings'
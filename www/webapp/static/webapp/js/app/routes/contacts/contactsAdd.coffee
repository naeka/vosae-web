Vosae.ContactsAddRoute = Ember.Route.extend
  model: ->
    @store.createRecord "contact"

  renderTemplate: ->
    @_super()
    @render 'contact.edit.settings',
      into: 'tenant'
      outlet: 'outletPageSettings'

  deactivate: ->
    model = @controller.get "content"
    model.rollback() if model
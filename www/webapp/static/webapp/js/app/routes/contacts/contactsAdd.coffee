Vosae.ContactsAddRoute = Ember.Route.extend
  init: ->
    @_super()
    @get('container').register 'controller:contacts.add', Vosae.ContactEditController

  model: ->
    Vosae.Contact.createRecord()

  setupController: (controller, model) ->
    controller.set 'content', model
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
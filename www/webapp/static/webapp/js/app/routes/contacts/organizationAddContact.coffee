Vosae.OrganizationAddContactRoute = Ember.Route.extend
  init: ->
    @_super()
    @get('container').register 'controller:organization.addContact', Vosae.ContactEditController

  setupController: (controller, model) ->
    organization = @modelFor("organization")
    
    contact = Vosae.Contact.createRecord(
      'organization': organization
    )
    
    controller.set 'content', contact
    controller.set 'organizations', Vosae.Organization.find()

  deactivate: ->
    contact = @controller.get 'content'
    if contact.get 'transaction'
      contact.get("transaction").rollback()

  renderTemplate: ->
    @_super()
    @render 'organization.edit.settings',
      into: 'application'
      outlet: 'outletPageSettings'
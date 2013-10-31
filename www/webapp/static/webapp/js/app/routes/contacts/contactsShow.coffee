Vosae.ContactsShowRoute = Ember.Route.extend
  model: ->
    Vosae.Contact.all()

  renderTemplate: ->
    @_super()
    @render 'contacts.show.settings',
      into: 'application'
      outlet: 'outletPageSettings'
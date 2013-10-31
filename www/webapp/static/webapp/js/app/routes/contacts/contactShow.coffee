Vosae.ContactShowRoute = Ember.Route.extend
  setupController: (controller, model) ->
    contact = @modelFor("contact")
    invoices = Vosae.Invoice.find(
      contact: contact.get('id')
      limit: 5
    )
    quotations = Vosae.Quotation.find(
      contact: contact.get('id')
      limit: 5
    )

    controller.set 'content', contact
    controller.set 'invoices', invoices
    controller.set 'quotations', quotations

  renderTemplate: ->
    @_super()
    @render 'contact.show.settings',
      into: 'application'
      outlet: 'outletPageSettings'
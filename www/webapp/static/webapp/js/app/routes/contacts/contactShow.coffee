Vosae.ContactShowRoute = Ember.Route.extend
  model: ->
    @modelFor("contact")

  setupController: (controller, model) ->
    invoices = @store.find 'invoice', {contact: model.get('id'), limit: 4}
    quotations = @store.find 'quotation', {contact: model.get('id'), limit: 4}

    controller.setProperties
      'content': model
      'invoices': invoices
      'quotations': quotations

  renderTemplate: ->
    @_super()
    @render 'contact.show.settings',
      into: 'tenant'
      outlet: 'outletPageSettings'
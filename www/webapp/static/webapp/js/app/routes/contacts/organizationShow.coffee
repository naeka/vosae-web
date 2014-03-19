Vosae.OrganizationShowRoute = Ember.Route.extend
  model: ->
    @modelFor("organization")

  setupController: (controller, model) ->
    invoices = @store.find 'invoice', {organization: model.get('id'), limit: 4}
    quotations = @store.find 'quotation', {organization: model.get('id'), limit: 4}

    controller.setProperties
      'content': model
      'invoices': invoices
      'quotations': quotations

  renderTemplate: ->
    @_super()
    @render 'organization.show.settings',
      into: 'tenant'
      outlet: 'outletPageSettings'
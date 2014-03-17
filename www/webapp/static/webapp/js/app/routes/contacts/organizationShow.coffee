Vosae.OrganizationShowRoute = Ember.Route.extend
  setupController: (controller, model) ->
    organization = @modelFor("organization")
    
    invoices = @store.find 'invoice',
      organization: organization.get('id')
      limit: 4

    quotations = @store.find 'quotation',
      organization: organization.get('id')
      limit: 4

    controller.setProperties
      'content': organization
      'invoices': invoices
      'quotations': quotations

  renderTemplate: ->
    @_super()
    @render 'organization.show.settings',
      into: 'application'
      outlet: 'outletPageSettings'
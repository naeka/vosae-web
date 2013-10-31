Vosae.OrganizationShowRoute = Ember.Route.extend
  setupController: (controller, model) ->
    organization = @modelFor("organization")
    invoices = Vosae.Invoice.find(
      organization: organization.get('id')
      limit: 5
    )
    quotations = Vosae.Quotation.find(
      organization: organization.get('id')
      limit: 5
    )
    
    controller.set 'content', organization
    controller.set 'invoices', invoices
    controller.set 'quotations', quotations

  renderTemplate: ->
    @_super()
    @render 'organization.show.settings',
      into: 'application'
      outlet: 'outletPageSettings'
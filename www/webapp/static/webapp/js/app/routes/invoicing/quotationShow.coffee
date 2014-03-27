Vosae.QuotationShowRoute = Ember.Route.extend
  model: ->
    @modelFor("quotation")

  setupController: (controller, model) ->
    controller.setProperties
      'content': model
      'invoicingSettings': @get('session.tenantSettings.invoicing')
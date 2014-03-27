Vosae.SettingsInvoicingGeneralRoute = Ember.Route.extend
  model: ->
    @get('session.tenantSettings')

  setupController: (controller, model) ->
    controller.setProperties
      'content': model
      'currencies': @store.all("currency").filterProperty('id')
      'paymentTypes': Vosae.Config.paymentTypes
  
  deactivate: ->
    model = @controller.get "content"
    model.rollback() if model
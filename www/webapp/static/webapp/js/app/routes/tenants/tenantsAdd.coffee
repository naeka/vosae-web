Vosae.TenantsAddRoute = Ember.Route.extend
  model: ->
    @store.createRecord('tenant')

  setupController: (controller, model) ->
    postalAddress = @store.createRecord "vosaeAddress"
    billingAddress = @store.createRecord "vosaeAddress"
    registrationInfo = @store.createRecord "frRegistrationInfo"

    model.setProperties
      'postalAddress': postalAddress
      'billingAddress': billingAddress
      'registrationInfo': registrationInfo

    controller.setProperties
      'content': model
      'currencies': @store.all('currency')
      'tenants': @store.all('tenant')

  deactivate: ->
    tenant = @controller.get 'content'
    tenant.rollback()

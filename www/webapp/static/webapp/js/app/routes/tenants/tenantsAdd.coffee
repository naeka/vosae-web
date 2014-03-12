Vosae.TenantsAddRoute = Ember.Route.extend
  model: ->
    Vosae.Tenant.createRecord()

  setupController: (controller, model) ->
    Vosae.lookup('controller:application').set('currentRoute', 'tenants.add')

    unusedTransaction = @get('store').transaction()
    postalAddress = unusedTransaction.createRecord Vosae.Address
    billingAddress = unusedTransaction.createRecord Vosae.Address
    registrationInfo = unusedTransaction.createRecord Vosae.FrRegistrationInfo

    model.setProperties
      'postalAddress': postalAddress
      'billingAddress': billingAddress
      'registrationInfo': registrationInfo

    controller.setProperties
      'content': model
      'unusedTransaction': unusedTransaction
      'currencies': Vosae.Currency.all().filterProperty('id')
      'tenants': Vosae.Tenant.all()

  deactivate: ->
    tenant = @controller.get 'content'
    if tenant.get 'isDirty'
      tenant.get('transaction').rollback()

    unusedTransaction = @controller.get 'unusedTransaction'
    unusedTransaction.rollback()
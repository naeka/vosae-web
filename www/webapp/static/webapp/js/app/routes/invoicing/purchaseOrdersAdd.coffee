Vosae.PurchaseOrdersAddRoute = Ember.Route.extend
  init: ->
    @_super()
    @get('container').register('controller:purchaseOrders.add', Vosae.PurchaseOrderEditController)

  model: ->
    Vosae.PurchaseOrder.createRecord()

  setupController: (controller, model) ->
    unusedTransaction = @get('store').transaction()
    currentRevision = unusedTransaction.createRecord Vosae.PurchaseOrderRevision
    currency = unusedTransaction.createRecord Vosae.Currency
    billingAddress = unusedTransaction.createRecord Vosae.Address
    deliveryAddress = unusedTransaction.createRecord Vosae.Address
    senderAddress = unusedTransaction.createRecord Vosae.Address

    senderAddress.setProperties
      'postofficeBox': @get "session.tenant.billingAddress.postofficeBox"
      'streetAddress': @get "session.tenant.billingAddress.streetAddress"
      'extendedAddress': @get "session.tenant.billingAddress.extendedAddress"
      'postalCode': @get "session.tenant.billingAddress.postalCode"
      'city': @get "session.tenant.billingAddress.city"
      'state': @get "session.tenant.billingAddress.state"
      'country': @get "session.tenant.billingAddress.country"
    
    currentRevision.get('lineItems').createRecord()
    currentRevision.setProperties
      'quotationDate': new Date()
      'sender': @get("session.user.fullName")
      'currency': currency
      'billingAddress': billingAddress
      'deliveryAddress': deliveryAddress
      'senderAddress': senderAddress

    currentRevision.set('contact', contact) if contact?
    currentRevision.set('organization', organization) if organization?

    model.setProperties
      'accountType': 'RECEIVABLE'
      'currentRevision': currentRevision

    controller.setProperties
      'content': model
      'unusedTransaction': unusedTransaction
      'taxes': Vosae.Tax.all()

  renderTemplate: ->
    @_super()
    @render 'purchaseOrder.edit.settings',
      into: 'application'
      outlet: 'outletPageSettings'

  deactivate: ->
    purchaseOrder = @controller.get 'content'
    if purchaseOrder.get 'isDirty'
      purchaseOrder.get("transaction").rollback()

    unusedTransaction = @controller.get 'unusedTransaction'
    unusedTransaction.rollback() if unusedTransaction
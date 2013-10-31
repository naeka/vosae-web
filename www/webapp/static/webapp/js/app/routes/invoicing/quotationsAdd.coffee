Vosae.QuotationsAddRoute = Ember.Route.extend
  preFillQuotationWith: {}

  init: ->
    @_super()
    @get('container').register('controller:quotations.add', Vosae.QuotationEditController)

  model: ->
    Vosae.Quotation.createRecord()

  setupController: (controller, model) ->
    # This is dirty and must be improved
    preFill = @get('preFillQuotationWith')
    if preFill
      contact = if preFill.contact then preFill.contact else null
      organization = if preFill.organization then preFill.organization else null

    unusedTransaction = @get('store').transaction()
    currentRevision = unusedTransaction.createRecord Vosae.InvoiceRevision
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

    currentRevision.set('contact', contact) if contact
    currentRevision.set('organization', organization) if organization

    model.setProperties
      'accountType': 'RECEIVABLE'
      'currentRevision': currentRevision

    controller.setProperties
      'content': model
      'unusedTransaction': unusedTransaction
      'taxes': Vosae.Tax.all()

  renderTemplate: ->
    @_super()
    @render 'quotation.edit.settings',
      into: 'application'
      outlet: 'outletPageSettings'

  deactivate: ->
    @set 'preFillQuotationWith', {}

    quotation = @controller.get 'content'
    if quotation.get 'isDirty'
      quotation.get("transaction").rollback()

    unusedTransaction = @controller.get 'unusedTransaction'
    unusedTransaction.rollback() if unusedTransaction
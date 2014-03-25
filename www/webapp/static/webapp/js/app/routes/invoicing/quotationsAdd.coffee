Vosae.QuotationsAddRoute = Ember.Route.extend
  controllerName: "quotationEdit"
  preFillQuotationWith: {}

  model: ->
    @store.createRecord "quotation"

  setupController: (controller, model) ->
    # This is dirty and must be improved
    preFill = @get('preFillQuotationWith')
    if preFill
      contact = if preFill.contact then preFill.contact else null
      organization = if preFill.organization then preFill.organization else null

    currentRevision = @store.createRecord "invoiceRevision"
    currency = @store.createRecord "snapshotCurrency"
    billingAddress = @store.createRecord "vosaeAddress"
    deliveryAddress = @store.createRecord "vosaeAddress"
    senderAddress = @store.createRecord "vosaeAddress"

    senderAddress.setProperties
      'postofficeBox': @get "session.tenant.billingAddress.postofficeBox"
      'streetAddress': @get "session.tenant.billingAddress.streetAddress"
      'extendedAddress': @get "session.tenant.billingAddress.extendedAddress"
      'postalCode': @get "session.tenant.billingAddress.postalCode"
      'city': @get "session.tenant.billingAddress.city"
      'state': @get "session.tenant.billingAddress.state"
      'country': @get "session.tenant.billingAddress.country"
    
    currentRevision.setProperties
      'quotationDate': new Date()
      'sender': @get("session.user.fullName")
      'currency': currency
      'billingAddress': billingAddress
      'deliveryAddress': deliveryAddress
      'senderAddress': senderAddress

    currentRevision.get('lineItems').createRecord()
    currentRevision.set('contact', contact) if contact
    currentRevision.set('organization', organization) if organization

    model.setProperties
      'accountType': 'RECEIVABLE'
      'currentRevision': currentRevision

    controller.setProperties
      'content': model
      'taxes': @store.all("tax")

  renderTemplate: ->
    @_super()
    @render 'quotation.edit.settings',
      into: 'tenant'
      outlet: 'outletPageSettings'

  deactivate: ->
    @set 'preFillQuotationWith', {}
    model = @controller.get "content"
    model.rollback() if model
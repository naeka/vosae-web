###
  A data model that represents a purchase order

  @class PurchaseOrder
  @extends Vosae.InvoiceBase
  @use Vosae.InvoiceMakableMixin
  @namespace Vosae
  @module Vosae
###

Vosae.PurchaseOrder = Vosae.InvoiceBase.extend Vosae.InvoiceMakableMixin,
  state: DS.attr('string')
  currentRevision: DS.belongsTo('purchaseOrderRevision')
  # revisions: DS.hasMany('purchaseOrderRevision')

  isPurchaseOrder: true

  displayState: (->
    # Returns the current state readable and translated.
    Vosae.Config.quotationStatesChoices.findProperty('value', @get('state')).get('label')
  ).property('state')

  availableStates: (->
    # List the available states for the `PurchaseOrder`, depending of its current state.
    if @get('state') is "DRAFT"
      Vosae.Config.purchaseOrderStatesChoices.filter (state) ->
        if ["AWAITING_APPROVAL", "APPROVED", "REFUSED"].contains state.get('value')
          state
    else if @get('state') is "AWAITING_APPROVAL"
      Vosae.Config.purchaseOrderStatesChoices.filter (state) ->
        if ["APPROVED", "REFUSED"].contains state.get('value')
          state
    else if @get('state') is "REFUSED"
      Vosae.Config.purchaseOrderStatesChoices.filter (state) ->
        if ["AWAITING_APPROVAL", "APPROVED"].contains state.get('value')
          state
    else
      return []
  ).property('state')

  isIssuable: (->
    # Determine if the `PurchaseOrder` could be sent.
    if ["DRAFT"].contains(@get('state')) or !@get('state')
      return false
    return true
  ).property('state')

  getErrors: ->
    # Return an array of string that contains form validation errors 
    errors = []
    errors = errors.concat @get("currentRevision").getErrors("PurchaseOrder")
    return errors
  
  makeInvoice: (controller) ->
    # Make an `Invoice` record from the `PurchaseOrder`.
    if @get('id') and @get('isInvoiceable')
      purchaseOrder = @
      purchaseOrder.set 'isMakingInvoice', true

      store = @get('store')
      adapter = store.adapterForType(Vosae.PurchaseOrder)
      serializer = adapter.get 'serializer'

      url = adapter.buildURL('purchase_order', @get('id'))
      url += "make_invoice/"

      adapter.ajax(url, "PUT").then (json) ->
        invoiceId = serializer.deurlify json['invoice_uri']
        if invoiceId
          purchaseOrder.reload()
          Em.run @, ->
            Vosae.SuccessPopup.open
              message: gettext 'Your purchase order has been transformed into an invoice'
            controller.transitionToRoute 'invoice.show', controller.get('session.tenant'), store.find(Vosae.Invoice, invoiceId)
          purchaseOrder.set 'isMakingInvoice', false
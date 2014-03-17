###
  This mixin help us to create invoices or down-payment invoices from
  documents like quotations or purchase orders.

  @class InvoiceMakableMixin
  @extends Ember.Mixin
  @namespace Vosae
  @module Vosae
###

Vosae.InvoiceMakableMixin = Ember.Mixin.create
  isMakingInvoice: false

  isInvoiceable: (->
    # `Quotation`/`PurchaseOrder` is invoiceable unless it has been invoiced.
    if @get('group.relatedInvoice')
      return false
    return true
  ).property('group.relatedInvoice')

  isModifiable: (->
    # `Quotation`/`PurchaseOrder` is modifiable unless it has been invoiced.
    if @get('group.relatedInvoice')
      return false
    return true
  ).property('group.relatedInvoice')

  isDeletable: (->
    # `Quotation`/`PurchaseOrder` is deletable if not linked to any
    # `Invoice` or `DownPaymentInvoice`.
    if @get('group.relatedInvoice') or not Em.isEmpty(@get('group.downPaymentInvoices')) or not @get('id')
      return false
    return true
  ).property('group.relatedInvoice', 'group.downPaymentInvoices.length', 'id')

  isInvoiced: (->
    # Returns true if the `Quotation` is invoiced.
    if @get('state') is "INVOICED"
      return true
    return false
  ).property('state')

  makeInvoice: (controller) ->
    # Make an `Invoice` record
    if @get('id') and @get('isInvoiceable')
      invoice_base = @
      invoice_base.set 'isMakingInvoice', true
      
      store = @get('store')
      adapter = store.adapterForType(Vosae.Quotation)
      serializer = adapter.get 'serializer'

      url = adapter.buildURL(@getEndpoint(), @get('id'))
      url += "make_invoice/"

      adapter.ajax(url, "PUT").then((json) ->
        invoiceId = serializer.deurlify json['invoice_uri']
        if invoiceId
          invoice_base.reload()
          Em.run @, ->
            if @get('isQuotation')
              Vosae.SuccessPopupComponent.open
                message: gettext 'Your quotation has been transformed into an invoice'
            else if @get('isPurchaseOrder')
              Vosae.SuccessPopupComponent.open
                message: gettext 'Your purchase order has been transformed into an invoice'
            controller.transitionToRoute 'invoice.show', controller.get('session.tenant'), store.find(Vosae.Invoice, invoiceId)
          invoice_base.set 'isMakingInvoice', false
      ).then null, adapter.rejectionHandler
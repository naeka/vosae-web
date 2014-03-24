###
  Custom object controller for a `Vosae.Quotation` record.

  @class QuotationShowController
  @extends Vosae.InvoiceBaseController
  @namespace Vosae
  @module Vosae
###

Vosae.QuotationShowController = Vosae.InvoiceBaseController.extend
  actions:
    makeInvoice: ->
      quotation = @get('content')

      # Make an `Invoice` record from the `Quotation`.
      if quotation.get('id') and quotation.get('isInvoiceable') and not quotation.get('isMakingInvoice')
        quotation.set 'isMakingInvoice', true
        
        store = @get('store')
        adapter = store.adapterFor "quotation"
        serializer = store.serializerFor "quotation"

        url = adapter.buildURL "quotation", quotation.get('id')
        url += "make_invoice/"

        adapter.ajax(url, "PUT").then (json) =>
          invoiceId = serializer.deurlify json['invoice_uri']
          if invoiceId
            quotation.reload()
            Vosae.SuccessPopup.open
              message: gettext 'Your quotation has been transformed into an invoice'
            @transitionToRoute 'invoice.show', @get('session.tenant'), store.find("invoice", invoiceId)
          quotation.set 'isMakingInvoice', false

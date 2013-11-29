Vosae.QuotationShowController = Vosae.InvoiceBaseController.extend
  actions:
    makeInvoice: ->
      @get('content').makeInvoice @
Vosae.PurchaseOrderShowController = Vosae.InvoiceBaseController.extend
  actions:
    makeInvoice: ->
      @get('content').makeInvoice @
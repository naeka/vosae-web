Vosae.PurchaseOrderShowController = Vosae.InvoiceBaseController.extend
  makeInvoice: ->
    @get('content').makeInvoice @
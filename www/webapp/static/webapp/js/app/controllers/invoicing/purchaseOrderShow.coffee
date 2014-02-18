###
  Custom object controller for a `Vosae.PurchaseOrder` record.

  @class PurchaseOrderShowController
  @extends Vosae.InvoiceBaseController
  @namespace Vosae
  @module Vosae
###

Vosae.PurchaseOrderShowController = Vosae.InvoiceBaseController.extend
  actions:
    makeInvoice: ->
      @get('content').makeInvoice @
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
      @get('content').makeInvoice @
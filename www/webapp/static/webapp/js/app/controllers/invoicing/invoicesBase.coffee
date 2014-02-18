###
  Custom array controller for a collection of `Vosae.InvoiceBase` based records.

  @class InvoiceBaseController
  @extends Vosae.ArrayController
  @namespace Vosae
  @module Vosae
###

Vosae.InvoicesBaseController = Vosae.ArrayController.extend
  sortProperties: ['currentRevision.dueDate']
  sortAscending: false

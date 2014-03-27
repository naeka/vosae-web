###
  A data model that represents a credit note

  @class CreditNote
  @extends Vosae.InvoiceBase
  @namespace Vosae
  @module Vosae
###

Vosae.CreditNote = Vosae.InvoiceBase.extend
  state: DS.attr('string')
  relatedDownPaymentInvoice: DS.belongsTo('downPaymentInvoice')
  relatedInvoice: DS.belongsTo('invoice')
  currentRevision: DS.belongsTo('creditNoteRevision')
  # revisions: DS.hasMany('creditNoteRevision')
  isCreditNote: true
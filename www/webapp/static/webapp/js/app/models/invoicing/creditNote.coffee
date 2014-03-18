###
  A data model that represents a credit note

  @class CreditNote
  @extends Vosae.InvoiceBase
  @namespace Vosae
  @module Vosae
###

Vosae.CreditNote = Vosae.InvoiceBase.extend
  state: DS.attr('string')
  currentRevision: DS.belongsTo('Vosae.CreditNoteRevision')
  # revisions: DS.hasMany('Vosae.CreditNoteRevision')
  relatedDownPaymentInvoice: DS.belongsTo('Vosae.DownPaymentInvoice')
  relatedInvoice: DS.belongsTo('Vosae.Invoice')

  isCreditNote: true


Vosae.Adapter.map "Vosae.CreditNote",
  # revisions:
  #   embedded: "always"
  ref:
    key: "reference"
  notes:
    embedded: "always"
  attachments:
    embedded: "always"
  currentRevision:
    embedded: "always"
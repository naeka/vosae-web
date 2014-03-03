###
  A data model that represents a down payement invoice

  @class DownPaymentInvoice
  @extends Vosae.Invoice
  @namespace Vosae
  @module Vosae
###

Vosae.DownPaymentInvoice = Vosae.Invoice.extend
  percentage: DS.attr('string')
  taxApplied: DS.belongsTo('Vosae.Tax')

Vosae.Adapter.map "Vosae.DownPaymentInvoice",
  # revisions:
  #   embedded: "always"
  ref:
    key: "reference"
  notes:
    embedded: "always"
  currentRevision:
    embedded: "always"
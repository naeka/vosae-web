###
  A data model that represents a invoice base group

  @class InvoiceBaseGroup
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.InvoiceBaseGroup = Vosae.Model.extend
  quotation: DS.belongsTo('quotation', inverse: null)
  purchaseOrder: DS.belongsTo('purchaseOrder', inverse: null)
  downPaymentInvoices: DS.hasMany('downPaymentInvoice', inverse: null)
  invoice: DS.belongsTo('invoice', inverse: null)
  invoicesCancelled: DS.hasMany('invoice', inverse: null)
  creditNotes: DS.hasMany('creditNote', inverse: null)

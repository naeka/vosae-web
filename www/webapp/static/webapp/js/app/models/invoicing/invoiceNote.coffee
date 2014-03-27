###
  A data model that represents an invoice note

  @class InvoiceNote
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.InvoiceNote = Vosae.Model.extend
  registrationDate: DS.attr('datetime')
  issuer: DS.belongsTo('user')
  note: DS.attr('string')

Vosae.InvoiceNote.reopen
  invoice: DS.belongsTo('invoice')
  quotation: DS.belongsTo('quotation')
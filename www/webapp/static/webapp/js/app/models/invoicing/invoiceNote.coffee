Vosae.InvoiceNote = DS.Model.extend
  registrationDate: DS.attr('datetime')
  issuer: DS.belongsTo('Vosae.User')
  note: DS.attr('string')

Vosae.InvoiceNote.reopen
  invoice: DS.belongsTo('Vosae.Invoice')
  quotation: DS.belongsTo('Vosae.Quotation')
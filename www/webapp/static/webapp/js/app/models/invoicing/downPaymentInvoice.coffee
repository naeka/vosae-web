Vosae.DownPaymentInvoice = Vosae.Invoice.extend
  percentage: DS.attr('string')
  taxApplied: DS.belongsTo('Vosae.Tax')

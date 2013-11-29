Vosae.InvoiceBaseGroup = DS.Model.extend
  quotation: DS.belongsTo('Vosae.Quotation', inverse: null)
  purchaseOrder: DS.belongsTo('Vosae.PurchaseOrder', inverse: null)
  downPaymentInvoices: DS.hasMany('Vosae.DownPaymentInvoice', inverse: null)
  invoice: DS.belongsTo('Vosae.Invoice', inverse: null)
  invoicesCancelled: DS.hasMany('Vosae.Invoice', inverse: null)
  creditNotes: DS.hasMany('Vosae.CreditNote', inverse: null)

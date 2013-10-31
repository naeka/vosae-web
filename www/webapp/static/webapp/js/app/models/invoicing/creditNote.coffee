Vosae.CreditNote = Vosae.InvoiceBase.extend
  state: DS.attr('string')
  relatedInvoice: DS.belongsTo('Vosae.Invoice')

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
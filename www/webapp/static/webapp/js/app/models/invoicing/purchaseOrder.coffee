Vosae.PurchaseOrder = Vosae.Quotation.extend()

Vosae.Adapter.map "Vosae.PurchaseOrder",
  # revisions:
  #   embedded: "always"
  ref:
    key: "reference"
  notes:
    embedded: "always"
  currentRevision:
    embedded: "always"
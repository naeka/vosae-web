###
  Serializer for model `Vosae.BaseRevision`.

  @class BaseRevisionSerializer
  @extends Vosae.ApplicationSerializer
  @namespace Vosae
  @module Vosae
###

Vosae.BaseRevisionSerializer = Vosae.ApplicationSerializer.extend
  attrs:
    senderAddress:
      embedded: "always"
    billingAddress:
      embedded: "always"
    deliveryAddress:
      embedded: "always"
    currency:
      embedded: "always"
    pdf:
      embedded: "always"
    lineItems:
      embedded: "always"

Vosae.CreditNoteRevisionSerializer = Vosae.BaseRevisionSerializer.extend()
Vosae.InvoiceRevisionSerializer = Vosae.BaseRevisionSerializer.extend()
Vosae.PurchaseOrderRevisionSerializer = Vosae.BaseRevisionSerializer.extend()
Vosae.QuotationRevisionSerializer = Vosae.BaseRevisionSerializer.extend()
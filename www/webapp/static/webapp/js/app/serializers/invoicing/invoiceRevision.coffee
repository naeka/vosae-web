###
  Serializer for model `Vosae.InvoiceRevision`.

  @class InvoiceRevisionSerializer
  @extends Vosae.ApplicationSerializer
  @namespace Vosae
  @module Vosae
###

Vosae.InvoiceRevisionSerializer = Vosae.ApplicationSerializer.extend
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
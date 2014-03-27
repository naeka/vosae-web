###
  Serializer for model `Vosae.DownPaymentInvoice`.

  @class DownPaymentInvoiceSerializer
  @extends Vosae.ApplicationSerializer
  @namespace Vosae
  @module Vosae
###

Vosae.DownPaymentInvoiceSerializer = Vosae.ApplicationSerializer.extend
  attrs:
    # revisions:
    #   embedded: "always"
    notes:
      embedded: "always"
    currentRevision:
      embedded: "always"
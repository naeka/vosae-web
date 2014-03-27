###
  Serializer for model `Vosae.Invoice`.

  @class InvoiceSerializer
  @extends Vosae.ApplicationSerializer
  @namespace Vosae
  @module Vosae
###

Vosae.InvoiceSerializer = Vosae.ApplicationSerializer.extend
  attrs:
    # revisions:
    #   embedded: "always"
    notes:
      embedded: "always"
    currentRevision:
      embedded: "always"
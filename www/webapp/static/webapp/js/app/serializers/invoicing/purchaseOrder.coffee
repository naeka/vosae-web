###
  Serializer for model `Vosae.PurchaseOrder`.

  @class PurchaseOrderSerializer
  @extends Vosae.ApplicationSerializer
  @namespace Vosae
  @module Vosae
###

Vosae.PurchaseOrderSerializer = Vosae.ApplicationSerializer.extend
  attrs:
    # revisions:
    #   embedded: "always"
    notes:
      embedded: "always"
    currentRevision:
      embedded: "always"
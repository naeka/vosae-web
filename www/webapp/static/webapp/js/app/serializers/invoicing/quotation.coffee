###
  Serializer for model `Vosae.Quotation`.

  @class QuotationSerializer
  @extends Vosae.ApplicationSerializer
  @namespace Vosae
  @module Vosae
###

Vosae.QuotationSerializer = Vosae.ApplicationSerializer.extend
  attrs:
    # revisions:
    #   embedded: "always"
    notes:
      embedded: "always"
    currentRevision:
      embedded: "always"
###
  Serializer for model `Vosae.CreditNote`.

  @class CreditNoteSerializer
  @extends Vosae.ApplicationSerializer
  @namespace Vosae
  @module Vosae
###

Vosae.CreditNoteSerializer = Vosae.ApplicationSerializer.extend
  attrs:
    # revisions:
    #   embedded: "always"
    notes:
      embedded: "always"
    currentRevision:
      embedded: "always"
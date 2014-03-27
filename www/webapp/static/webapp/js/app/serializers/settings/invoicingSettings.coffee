###
  Serializer for model `Vosae.InvoicingSettings`.

  @class InvoicingSettingsSerializer
  @extends Vosae.ApplicationSerializer
  @namespace Vosae
  @module Vosae
###

Vosae.InvoicingSettingsSerializer = Vosae.ApplicationSerializer.extend
  attrs:
    numbering:
      embedded: "always"

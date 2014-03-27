###
  Serializer for model `Vosae.CoreSettings`.

  @class CoreSettingsSerializer
  @extends Vosae.ApplicationSerializer
  @namespace Vosae
  @module Vosae
###

Vosae.CoreSettingsSerializer = Vosae.ApplicationSerializer.extend
  attrs:
    quotas:
      embedded: "always"
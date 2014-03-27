###
  Serializer for model `Vosae.Tenant`.

  @class TenantSerializer
  @extends Vosae.ApplicationSerializer
  @namespace Vosae
  @module Vosae
###

Vosae.TenantSerializer = Vosae.ApplicationSerializer.extend
  attrs:
    registrationInfo:
      embedded: "always"
    postalAddress:
      embedded: "always"
    billingAddress:
      embedded: "always"
    reportSettings:
      embedded: "always"
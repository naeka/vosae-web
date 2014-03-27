###
  Serializer for model `Vosae.Organization`.

  @class OrganizationSerializer
  @extends Vosae.ApplicationSerializer
  @namespace Vosae
  @module Vosae
###

Vosae.OrganizationSerializer = Vosae.ApplicationSerializer.extend
  attrs:
    addresses:
      embedded: "always"
    emails:
      embedded: "always"
    phones:
      embedded: "always"
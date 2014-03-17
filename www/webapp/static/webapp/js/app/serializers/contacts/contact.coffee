###
  Serializer for model `Vosae.Contact`.

  @class ContactSerializer
  @extends Vosae.ApplicationSerializer
  @namespace Vosae
  @module Vosae
###

Vosae.ContactSerializer = Vosae.ApplicationSerializer.extend
  attrs:
    addresses:
      embedded: "always"
    emails:
      embedded: "always"
    phones:
      embedded: "always"
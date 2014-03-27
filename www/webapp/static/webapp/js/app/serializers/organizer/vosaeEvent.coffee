###
  Serializer for model `Vosae.VosaeEvent`.

  @class VosaeEventSerializer
  @extends Vosae.ApplicationSerializer
  @namespace Vosae
  @module Vosae
###

Vosae.VosaeEventSerializer = Vosae.ApplicationSerializer.extend
  attrs:
    start:
      embedded: "always"
    end:
      embedded: "always"
    originalStart:
      embedded: "always"
    attendees:
      embedded: "always"
    reminders:
      embedded: "always"
###
  Serializer for model `Vosae.CalendarAcl`.

  @class CalendarAclSerializer
  @extends Vosae.ApplicationSerializer
  @namespace Vosae
  @module Vosae
###

Vosae.CalendarAclSerializer = Vosae.ApplicationSerializer.extend
  attrs:
    rules:
      embedded: "always"
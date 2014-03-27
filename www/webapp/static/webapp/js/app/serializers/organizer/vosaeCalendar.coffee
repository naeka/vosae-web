###
  Serializer for model `Vosae.VosaeCalendar`.

  @class VosaeCalendarSerializer
  @extends Vosae.ApplicationSerializer
  @namespace Vosae
  @module Vosae
###

Vosae.VosaeCalendarSerializer = Vosae.ApplicationSerializer.extend
  attrs:
    acl:
      embedded: "always"
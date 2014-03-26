###
  Serializer for model `Vosae.CalendarList`.

  @class CalendarListSerializer
  @extends Vosae.ApplicationSerializer
  @namespace Vosae
  @module Vosae
###

Vosae.CalendarListSerializer = Vosae.ApplicationSerializer.extend
  attrs:
    reminders:
      embedded: "always"
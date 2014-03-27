###
  Serializer for model `Vosae.ReminderSettings`.

  @class ReminderSettingsSerializer
  @extends Vosae.ApplicationSerializer
  @namespace Vosae
  @module Vosae
###

Vosae.ReminderSettingsSerializer = Vosae.ApplicationSerializer.extend
  attrs:
    overrides:
      embedded: "always"
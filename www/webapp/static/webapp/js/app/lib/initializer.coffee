###
  @module ember-data
  @submodule embedded-adapter
###

Ember.onLoad 'Ember.Application', (Application) ->
  Application.initializer
    name: "embeddedAdapter"

    initialize: (container, application) ->
      application.register 'serializer:_embedded', DS.EmbeddedSerializer
      application.register 'adapter:_embedded', DS.EmbeddedAdapter
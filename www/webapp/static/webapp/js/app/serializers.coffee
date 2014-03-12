DS.EmbeddedSerializer.reopen
  ###
    Parse `resource_uri` and returns `id`. This method is called when
    extracting `hasMany` & `belongsTo` relationships
  ###
  deurlify: (value) ->
    if typeof value is "string"
      return value.split("/").reverse()[1]
    value

  ###
    Extract all meta from requests
  ###
  extractMeta: (store, type, payload) ->
    if payload and payload.meta
      meta = Em.Object.createWithMixins Vosae.MetaMixin, payload.meta
      store.metaForType type, meta
      delete payload.meta

require 'serializers/application'

require 'serializers/core/timeline'
require 'serializers/core/tenant'
require 'serializers/core/tenantSettings'
require 'serializers/core/user'

# require 'serializers/contacts/address'

require 'serializers/invoicing/currency'

require 'serializers/settings/coreSettings'
require 'serializers/settings/invoicingSettings'

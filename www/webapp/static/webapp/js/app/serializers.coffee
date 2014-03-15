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
    Extract all meta from request
  ###
  extractMeta: (store, type, payload) ->
    if payload and payload.meta
      payload.meta.since = if payload.meta.offset? then payload.meta.offset + payload.meta.limit else 0
      payload.meta.totalCount = payload.meta.total_count
      delete payload.meta.total_count
      store.metaForType(type, payload.meta)
      delete payload.meta

require 'serializers/application'

require 'serializers/core/notification'
require 'serializers/core/timeline'
require 'serializers/core/tenant'
require 'serializers/core/tenantSettings'
require 'serializers/core/user'

# require 'serializers/contacts/address'

require 'serializers/invoicing/currency'

require 'serializers/settings/coreSettings'
require 'serializers/settings/invoicingSettings'

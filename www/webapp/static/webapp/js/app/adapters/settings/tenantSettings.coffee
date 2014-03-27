###
  Custom adapter for model `Vosae.TenantSettings`.

  @class TenantSettingsAdapter
  @extends Vosae.ApplicationAdapter
  @namespace Vosae
  @module Vosae
###

Vosae.TenantSettingsAdapter = Vosae.ApplicationAdapter.extend

  ###
    The endpoint for model `Vosae.TenantSettings` is a special endpoint that do
    no requires the record ID for a "PUT" request.
  ###
  updateRecord: (store, type, record) ->
    data = {}
    serializer = store.serializerFor type.typeKey

    serializer.serializeIntoHash(data, type, record).then (serialized) =>
      @ajax @buildURL(type.typeKey), "PUT", data: serialized.object
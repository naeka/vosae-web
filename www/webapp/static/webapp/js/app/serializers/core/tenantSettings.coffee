###
  This custom serializer is needed because the endpoint for the model `Vosae.TenantSettings`
  is a specific endpoint. The main serializer expect to get a collection of records after a
  GET on `/api/v1/tenant_settings` whereas it returns a unique record.

  @class TenantSettingsSerializer
  @extends Vosae.ApplicationSerializer
  @namespace Vosae
  @module Vosae
###

Vosae.TenantSettingsSerializer = Vosae.ApplicationSerializer.extend
  attrs:
    core:
      embedded: "always"
    invoicing:
      embedded: "always"

  ###
    API will return a specific payload like this:
    {
      "core": {
        "quotas": {
          "allocated_space": 1073741824,
          "used_space": 108333,
          (...)
        }
      },
      "invoicing": {
        "automatic_reminders": false,
        "automatic_reminders_send_copy": true,
        "automatic_reminders_text": null,
        (...)
      }
    }
    
    We must transform it to this payload

    {
      "objects": [{
        "core": {
          "quotas": {
            "allocated_space": 1073741824,
            "used_space": 108333,
            (...)
          }
        },
        "invoicing": {
          "automatic_reminders": false,
          "automatic_reminders_send_copy": true,
          "automatic_reminders_text": null,
          (...)
        }
      }]
    }

    Calling `this._super()` will do the rest of the job.
  ###
  extractArray: (store, primaryType, payload) ->
    tenantSettings = payload
    tenantSettings.id = "tenant_settings_1"
    payload = {}
    payload.objects = []
    payload.objects.push tenantSettings

    return @_super store, primaryType, payload

  extractSingle: (store, primaryType, payload) ->
    payload.id = "tenant_settings_1"

    return @_super store, primaryType, payload

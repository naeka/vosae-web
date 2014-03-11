# ###
#   This customer adapter is mainly used to fetch the tenantSettings
#   on the API. `api/v1/tenant_settings` is a specific end point that
#   always returns a SIGNLE record.
# ###

# Vosae.TenantSettingsAdapter = Vosae.ApplicationAdapter.extend
#   find: (store, type, id) ->
#     console.log 'here :)'
#     # Remove the id from the URL
#     return @ajax(this.buildURL(type.typeKey), 'GET')

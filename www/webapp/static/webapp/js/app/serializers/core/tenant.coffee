Vosae.TenantSerializer = Vosae.ApplicationSerializer.extend
  attrs:
    registrationInfo:
      embedded: "always"
    postalAddress:
      embedded: "always"
    billingAddress:
      embedded: "always"
    reportSettings:
      embedded: "always"

  normalizeHash:
    tenants: (hash) ->
      hash.registrationInfo = hash.registration_info_id
      hash.registrationInfoType = hash.registration_info_type
      delete hash.registration_info_id
      delete hash.registration_info_type
      delete hash.resource_uri

      return hash

      
      
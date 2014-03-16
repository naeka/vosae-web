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

  # extractArray: (store, primaryType, payload) ->
  #   payload.objects.forEach (tenant, i) ->
  #     delete payload.objects[i].svg_logo
  #     delete payload.objects[i].img_logo
  #     delete payload.objects[i].terms
  #     delete payload.objects[i].resource_uri
  #     delete payload.objects[i].billing_address
  #     delete payload.objects[i].registration_info
  #     delete payload.objects[i].report_settings
  #     delete payload.objects[i].postal_address.country
  #     delete payload.objects[i].postal_address.extended_address
  #     delete payload.objects[i].postal_address.geo_point
  #     delete payload.objects[i].postal_address.label
  #     delete payload.objects[i].postal_address.postal_code
  #     delete payload.objects[i].postal_address.postoffice_box
  #     delete payload.objects[i].postal_address.state
  #     delete payload.objects[i].postal_address.street_address
  #     delete payload.objects[i].postal_address.type

  #   return @_super store, primaryType, payload
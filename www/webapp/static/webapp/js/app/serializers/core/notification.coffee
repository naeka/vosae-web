Vosae.NotificationSerializer = DS.EmbeddedSerializer.extend
  
  ###
    Format the notification entry resource_type for Ember data. If resource_type
    is `quotation_saved_ne` it must match the model `Vosae.QuotationSavedNE` 
    so ember data expect to find the key `quotationSavedNEs` in the payload
  ###
  rootTypeForResource: (resourceType) ->
    resourceType = resourceType.substring(0, resourceType.length - 2) + "NE"
    return resourceType.camelize().pluralize()

  extractArray: (store, primaryType, payload) ->
    notificationEntries = payload.objects
    payload = {}
    payload.notifications = []

    for ne in notificationEntries
      # Create root key in payload
      type = @rootTypeForResource ne.resource_type
      payload[type] = payload[type] or []
      
      # Deurlify issuer belongsTo url
      ne.issuer_id = @deurlify ne.issuer

      # Delete unwanted properties
      delete ne.issuer
      delete ne.resource_type
      delete ne.resource_uri

      payload[type].push(ne)

    return @_super store, primaryType, payload
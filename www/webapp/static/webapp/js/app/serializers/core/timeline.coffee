Vosae.TimelineSerializer = Vosae.ApplicationSerializer.extend
  
  ###
    Format the timeline entry resource type for Ember data. If resource type
    is `quotation_saved_te` it must match the model `Vosae.QuotationSavedTE` 
    so ember data expect to find the key `quotationSavedTEs` in the payload
  ###
  rootTypeForResource: (resourceType) ->
    resourceType = resourceType.substring(0, resourceType.length - 2) + "TE"
    return resourceType.camelize().pluralize()

  extractArray: (store, primaryType, payload) ->
    for te in payload.objects
      # Create root key in payload
      type = @rootTypeForResource te.resource_type
      payload[type] = payload[type] or []
      
      # Deurlify issuer belongsTo url
      te.issuer = @deurlify te.issuer

      # Delete unwanted properties
      delete te.resource_type
      delete te.resource_uri

      payload[type].push(te)

    payload.objects = []
    
    return @_super store, primaryType, payload
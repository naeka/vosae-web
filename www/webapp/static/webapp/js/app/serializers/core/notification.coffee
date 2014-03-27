###
  Serializer for model `Vosae.Notification` and all polymorphic sub models.

  @class NotificationSerializer
  @extends Vosae.ApplicationSerializer
  @namespace Vosae
  @module Vosae
###

Vosae.NotificationSerializer = Vosae.ApplicationSerializer.extend
  
  ###
    Format the notification entry resource_type for Ember data. If resource_type
    is `quotation_saved_ne` it must match the model `Vosae.QuotationSavedNE` 
    so ember data expect to find the key `quotationSavedNEs` in the payload
  ###
  rootTypeForResource: (resourceType) ->
    resourceType = resourceType.substring(0, resourceType.length - 2) + "NE"
    return resourceType.camelize().pluralize()

  extractArray: (store, primaryType, payload) ->
    for ne in payload.objects
      # Create root key in payload
      type = @rootTypeForResource ne.resource_type
      payload[type] = payload[type] or []
      delete ne.resource_type

      payload[type].push(ne)

    payload.notifications = []
    delete payload.objects

    for root of payload
      partials = payload[root]
      secondaryType = store.modelFor(root.singularize())
      Ember.EnumerableUtils.forEach partials, ((partial) ->
        updatePayload.call this, store, secondaryType, payload, partial
        return
      ), this

    return @_super store, primaryType, payload

updatePayload = (store, type, payload, partial) ->
  type.eachRelationship ((key, relationship) ->
    updatePayloadWithBelongsTo.call this, store, key, relationship, payload, partial if relationship.kind is "belongsTo"
    return
  ), this
  return

# Handles `belongsTo` relationship, deurlify content
updatePayloadWithBelongsTo = (store, primaryType, relationship, payload, partial) ->
  serializer = store.serializerFor(relationship.type.typeKey)
  attribute = serializer.keyForAttribute(primaryType)
  url = partial[attribute]
  partial[attribute] = serializer.deurlify(url) if url
  return
###
  Serializer for model `Vosae.Timeline` and all polymorphic sub models.

  @class TimelineSerializer
  @extends Vosae.ApplicationSerializer
  @namespace Vosae
  @module Vosae
###

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
      delete te.resource_type

      payload[type].push(te)

    payload.timelines = []
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
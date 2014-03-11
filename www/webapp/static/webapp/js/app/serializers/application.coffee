inflector = Ember.Inflector.inflector
inflector.irregular 'reportSettings', 'reportSettings'
inflector.irregular 'userSettings', 'userSettings'
inflector.irregular 'tenantSettings', 'tenantSettings'
inflector.irregular 'coreSettings', 'coreSettings'
inflector.irregular 'invoicingSettings', 'invoicingSettings'

Vosae.ApplicationSerializer = DS.EmbeddedSerializer.extend

  payloadRootForType: (type) ->
    type.toString().split('.')[1].pluralize().decamelize()

  extractArray: (store, primaryType, payload) ->
    root = @payloadRootForType(primaryType)
    payload[root] = payload.objects  
    delete payload.objects
  
    if @attrs and Em.typeOf(@attrs) is "object"
      attrsKeys = Object.keys @attrs
      for parentRecord in payload[root]
        for key in attrsKeys
          attr = @attrs[key]
          # relationship is embedded in payload
          if attr.embedded and attr.embedded == "always"
            extractedEmbedded = parentRecord[key.decamelize()]
            # belongsTo embedded relationship
            if extractedEmbedded and Em.typeOf(extractedEmbedded) is "object"
              if !extractedEmbedded.id
                extractedEmbedded.id = parentRecord.id + "_" + key.decamelize()
            # hasMany embedded relationship
            else if extractedEmbedded and Em.typeOf(extractedEmbedded) is "array"
              for record, i in extractedEmbedded
                if !record.id
                  record.id = parentRecord.id + "_" + key.decamelize() + "_" + i

    return @_super store, primaryType, payload
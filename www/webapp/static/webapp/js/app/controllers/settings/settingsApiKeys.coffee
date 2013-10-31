Vosae.SettingsApiKeysController = Em.ObjectController.extend
  filteredApiKeys: (->
    apiKeys = @get('apiKeys').filter (apiKey) ->
      apiKey if apiKey.get("id") and not apiKey.get("isDeleted")
    return apiKeys
  ).property('apiKeys.@each', 'apiKeys.length', 'apiKeys.@each.id')

  save: (apiKey) ->
    apiKey.one "didCreate", @, ->
      @notifyPropertyChange('apiKeys.length')
    apiKey.get('transaction').commit()

  delete: (apiKey) ->
    Vosae.ConfirmPopupComponent.open
      message: gettext 'Do you really want to revoke this API key?'
      callback: (opts, event) =>
        if opts.primary
          apiKey.deleteRecord()
          apiKey.get('transaction').commit()

  add: ->
    transaction = @get('store').transaction()
    @setProperties
      content: transaction.createRecord(Vosae.ApiKey)
      apiKeys: Vosae.ApiKey.all()

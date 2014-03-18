###
  Custom controller for a collection of `Vosae.ApiKey` records.

  @class SettingsApiKeysController
  @extends Vosae.ArrayController
  @namespace Vosae
  @module Vosae
###

Vosae.SettingsApiKeysController = Vosae.ArrayController.extend
  filteredApiKeys: (->
    apiKeys = @get('content').filter (apiKey) ->
      apiKey if apiKey.get("id")
  ).property('content.@each', 'content.length', 'content.@each.id')

  # Actions handlers
  actions:
    saveNewApiKey: (apiKey) ->
      apiKey.get('transaction').commit()

    deleteApiKey: (apiKey) ->
      Vosae.ConfirmPopup.open
        message: gettext 'Do you really want to revoke this API key?'
        callback: (opts, event) =>
          if opts.primary
            t = @get('store').transaction()
            t.adoptRecord apiKey
            apiKey.deleteRecord()
            apiKey.get('transaction').commit()

    createNewApiKey: ->
      @set 'newApiKey', Vosae.ApiKey.createRecord()

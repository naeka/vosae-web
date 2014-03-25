###
  Custom controller for a collection of `Vosae.ApiKey` records.

  @class SettingsApiKeysController
  @extends Vosae.ArrayController
  @namespace Vosae
  @module Vosae
###

Vosae.SettingsApiKeysController = Vosae.ArrayController.extend
  relatedType: "apiKey"

  filteredApiKeys: (->
    apiKeys = @get('content').filter (apiKey) ->
      apiKey if apiKey.get("id")
  ).property('content.length', 'content.@each.id')

  # Actions handlers
  actions:
    saveNewApiKey: (apiKey) ->
      apiKey.save()

    deleteApiKey: (apiKey) ->
      Vosae.ConfirmPopup.open
        message: gettext 'Do you really want to revoke this API key?'
        callback: (opts, event) =>
          if opts.primary
            apiKey.deleteRecord()
            apiKey.save()

    createNewApiKey: ->
      @set 'newApiKey', @get('store').createRecord("apiKey")

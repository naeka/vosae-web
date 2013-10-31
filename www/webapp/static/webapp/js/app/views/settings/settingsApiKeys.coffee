Vosae.SettingsApiKeysView = Vosae.PageSettingsView.extend
  classNames: ["outlet-settings", "page-api-keys"]

  didInsertElement: ->
    @_super()
    # Focus on first input text
    @.$().find('.ember-text-field').first().focus()
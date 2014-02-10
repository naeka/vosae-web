Vosae.SettingsApiKeysView = Vosae.PageSettingsView.extend
  classNames: ["outlet-settings", "page-api-keys"]

  didInsertElement: ->
    @_super()
    # Focus on first input text
    @.$().find('.ember-text-field').first().focus()

  apiKeyName: Vosae.AutoGrowTextField.extend
    valueBinding: "parentView.controller.newApiKey.label"
    maxlength: "64"
    disabledBinding: "parentView.controller.newApiKey.key"
    classNames: "form-control form-control-settings inline-block" 
    placeholder: gettext "Name here"

  apiKeyKey: Vosae.AutoGrowTextField.extend
    valueBinding: "parentView.controller.newApiKey.key"
    maxlength: "64"
    disabled: true
    classNames: "form-control form-control-settings inline-block" 
    placeholder: gettext "Name here"
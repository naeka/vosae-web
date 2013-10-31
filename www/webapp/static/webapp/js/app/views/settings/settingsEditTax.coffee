Vosae.SettingsEditTaxView = Vosae.PageSettingsView.extend
  classNames: ["outlet-settings"]

  didInsertElement: ->
    @_super()
    # Focus on first input text
    @.$().find('.ember-text-field').first().focus()

  rateField: Vosae.AutoNumericField.extend 
    focusOut: (evt) ->
      @set('rate', (@.$().autoNumeric('get')/100))
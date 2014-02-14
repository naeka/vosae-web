Vosae.SettingsInvoicingGeneralView = Vosae.PageSettingsView.extend
  classNames: ["outlet-settings", "page-settings-invoicingGeneral"]

  supportedCurrencies: Vosae.Select.extend
    change: ->
      # Theses lines fix a fucking bug on records currentState
      @set 'parentView.controller.content.currentState', DS.RootState.loaded.updated.uncommitted
      @set 'parentView.controller.content.invoicing.currentState', DS.RootState.loaded.updated.uncommitted
      @set 'parentView.controller.content.invoicing.numbering.currentState', DS.RootState.loaded.updated.uncommitted

  defaultCurrency: Vosae.Select.extend()

  paymentTypes: Vosae.Select.extend
    change: ->
      # Theses lines fix a fucking bug on records currentState
      @set 'parentView.controller.content.currentState', DS.RootState.loaded.updated.uncommitted
      @set 'parentView.controller.content.invoicing.currentState', DS.RootState.loaded.updated.uncommitted
      @set 'parentView.controller.content.invoicing.numbering.currentState', DS.RootState.loaded.updated.uncommitted
  
  lateFeeRate: Vosae.TextFieldAutoNumeric.extend
    focusOut: (evt) ->
      @get('invoicing').set "lateFeeRate", @.$().autoNumeric('get')

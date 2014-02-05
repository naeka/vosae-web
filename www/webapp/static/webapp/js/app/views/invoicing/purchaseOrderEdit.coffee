Vosae.PurchaseOrderEditView = Vosae.QuotationEditView.extend

  purchaseOrderDateField: Vosae.DatePickerField.extend
    didInsertElement: ->
      @_super()
      element = @$().closest('.invoice-head .date')

      date = @get('currentRevision.purchaseOrderDate')
      if date?
        element.attr 'data-date', moment(date).format("L")

      element
        .datepicker(@datepicker_settings)
        .on "changeDate", (ev) =>
          console.log ev.date
          @get("currentRevision").set "purchaseOrderDate", ev.date
          element.datepicker 'hide'

Vosae.PurchaseOrderEditSettingsView = Vosae.QuotationEditSettingsView.extend()
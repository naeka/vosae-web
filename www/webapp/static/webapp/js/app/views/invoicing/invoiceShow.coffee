Vosae.InvoiceShowView = Em.View.extend
  classNames: ["page-show-invoice"]

  # ============
  # = Payments =
  # ============
  paymentDateField: Vosae.DatePickerField.extend
    didInsertElement: ->
      @_super()
      payment = @get 'payment'

      @$()
        .val(moment(payment.get("date")).format("L"))
        .datepicker(@datepicker_settings)
        .on "changeDate", (ev) =>
          payment.set "date", ev.date

  paymentCurrencyField: Vosae.Components.Select.extend(
    didInsertElement: ->      
      payment = @get('payment')
      
      # Select currency of the `currentRevision`
      @$().val payment.get('currency.symbol')

      @_super()

    change: ->
      currency = Vosae.Currency.all().findProperty 'symbol', @get('value')
      @get('payment').updateWithCurrency currency
  )

  paymentAmountField: Vosae.AutoNumericField.extend(
    didInsertElement: ->
      @_super()
      amount = @get 'payment.relatedTo.balance'
      @get('payment').set "amount", amount
      @.$().autoNumeric 'set', amount

      @addDisplayAmountObserver()

    willDestroyElement: ->
      @removeDisplayAmountObserver()

    addDisplayAmountObserver: ->
      @get('payment').addObserver "displayAmount", @, ->
        unless @get('payment.displayAmount') is @.$().autoNumeric('get')
          @.$().autoNumeric 'set', @get('payment.displayAmount')

    removeDisplayAmountObserver: ->
      @get('payment').removeObserver "displayAmount"

    focusOut: (evt) ->
      amount = @.$().autoNumeric('get')
      amountMax = @get('payment.amountMax')

      if amount > amountMax
        @get('payment').set "amount", amountMax
        @.$().autoNumeric 'set', amountMax
      else
        @get('payment').set "amount", amount
  )

  paymentNoteField: Vosae.TextAreaAutoSize.extend(

  )

  paymentTypeField: Vosae.Components.Select.extend(

  )
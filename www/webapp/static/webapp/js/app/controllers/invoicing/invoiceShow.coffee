Vosae.InvoiceShowController = Vosae.InvoiceBaseController.extend
  invoiceCancel: ->
    @get('content').invoiceCancel @

  addPayment: ->
    date = new Date()
    invCurrency = @get('content.currentRevision.currency')
    currency = Vosae.Currency.all().findProperty 'symbol', invCurrency.get('symbol')
    invoice = @get('content')
    @get("content.payments").createRecord
      date: date
      currency: currency
      type: 'CASH'
      relatedTo: invoice

    @get('content').notifyPropertyChange "canAddPayment"

  savePayment: (payment) ->
    unless payment.get('isSaving')
      invoice = @get('content')
      payment.one "didCreate", @, ->
        invoice.reload()
      payment.get('transaction').commit()

  # deletePayment: (payment) ->
  #   if confirm('Do you really want to delete this payment ?')
  #     unless payment.get('isSaving')
  #       payment.deleteRecord()
  #       payment.get('transaction').commit()
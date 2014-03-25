###
  Custom object controller for a `Vosae.Invoice` record.

  @class InvoiceShowController
  @extends Vosae.InvoiceBaseController
  @namespace Vosae
  @module Vosae
###

Vosae.InvoiceShowController = Vosae.InvoiceBaseController.extend
  actions:
    invoiceCancel: ->
      # Cancel the invoice and returns the associated credit note.
      if @get('id') and @get('isCancelable') and not @get('isCancelling')
        invoice = @get('content')
        invoice.set 'isCancelling', true
       
        store = @get('store')
        adapter = store.adapterFor "invoice"
        serializer = store.serializerFor "invoice"

        url = adapter.buildURL "invoice", invoice.get('id')
        url += "cancel/"

        adapter.ajax(url, "PUT").then (json) =>
          creditNoteId = serializer.deurlify json['credit_note_uri']
          if creditNoteId
            invoice.reload()
            Vosae.SuccessPopup.open
              message: gettext 'Your invoice has been cancelled' 
            @transitionToRoute 'creditNote.show', @get('session.tenant'), store.find("creditNote", creditNoteId)
          invoice.set 'isCancelling', false

    addPayment: ->
      date = new Date()
      invoice = @get('content')
      invCurrency = invoice.get('currentRevision.currency')
      currency = @get('store').all('currency').findProperty 'symbol', invCurrency.get('symbol')
      @get("content.payments").then (payments) =>
        payments.createRecord
          date: date
          currency: currency
          type: 'CASH'
          relatedTo: invoice
        invoice.notifyPropertyChange "canAddPayment"

    savePayment: (payment) ->
      unless payment.get('isSaving')
        invoice = @get('content')
        payment.save().then () =>
          invoice.reload()

    # deletePayment: (payment) ->
    #   if confirm('Do you really want to delete this payment ?')
    #     unless payment.get('isSaving')
    #       payment.deleteRecord()
    #       payment.get('transaction').commit()
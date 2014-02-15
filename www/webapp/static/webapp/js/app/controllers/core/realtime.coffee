Vosae.RealtimeController = Em.ArrayController.extend
  pusher: null
  userChannel: null
  needs: "dashboardShow"
  dashboardBinding: "controllers.dashboardShow"

  init: ->
    @_super()

    # Pusher subscriptions
    @pusher = new Pusher Vosae.Config.PUSHER_KEY,
      cluster: Vosae.Config.PUSHER_CLUSTER
      authEndpoint: Vosae.Config.PUSHER_AUTH_ENDPOINT
      authTransport: 'jsonp'
    @userChannel = @pusher.subscribe Vosae.Config.PUSHER_USER_CHANNEL

    # Pusher notification binding
    @userChannel.bind 'new-notification', (data) =>
      @getNotificationSubModel(data.type).find(data.id)
      
    # Pusher timeline binding
    @userChannel.bind 'new-timeline-entry', (data) =>
      @getTimelineSubModel(data.type).find(data.id).then (timelineEntry) =>
        @get('dashboard').updateContentFrom(1, 2)

    # Pusher statistics binding
    @userChannel.bind 'statistics-update', (data) =>
      for statistics in data.statistics
        Vosae.lookup("controller:#{statistics}").fetchResults()

  getTimelineSubModel: (type) ->
    switch type
      when 'contact_saved_te' then Vosae.ContactSavedTE
      when 'organization_saved_te' then Vosae.OrganizationSavedTE
      when 'quotation_saved_te' then Vosae.QuotationSavedTE
      when 'invoice_saved_te' then Vosae.InvoiceSavedTE
      when 'down_payment_invoice_saved_te' then Vosae.DownPaymentInvoiceSavedTE
      when 'credit_note_saved_te' then Vosae.CreditNoteSavedTE
      when 'quotation_changed_state_te' then Vosae.QuotationChangedStateTE
      when 'invoice_changed_state_te' then Vosae.InvoiceChangedStateTE
      when 'down_payment_invoice_changed_state_te' then Vosae.DownPaymentInvoiceChangedStateTE
      when 'credit_note_changed_state_te' then Vosae.CreditNoteChangedStateTE
      when 'quotation_make_invoice_te' then Vosae.QuotationMakeInvoiceTE
      when 'quotation_make_down_payment_invoice_te' then Vosae.QuotationMakeDownPaymentInvoiceTE
      when 'invoice_cancelled_te' then Vosae.InvoiceCancelledTE
      when 'down_payment_invoice_cancelled_te' then Vosae.DownPaymentInvoiceCancelledTE
      else Vosae.Timeline

  getNotificationSubModel: (type) ->
    switch type
      when 'contact_saved_ne' then Vosae.ContactSavedNE
      when 'organization_saved_ne' then Vosae.OrganizationSavedNE
      when 'quotation_saved_ne' then Vosae.QuotationSavedNE
      when 'invoice_saved_ne' then Vosae.InvoiceSavedNE
      when 'down_payment_invoice_saved_ne' then Vosae.DownPaymentInvoiceSavedNE
      when 'credit_note_saved_ne' then Vosae.CreditNoteSavedNE
      when 'event_reminder_ne' then Vosae.EventReminderNE
      else Vosae.Notification

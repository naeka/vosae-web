###
  Custom object controller for a `Vosae.InvoiceBase` based record.

  @class InvoiceBaseController
  @extends Ember.ObjectController
  @namespace Vosae
  @module Vosae
###

Vosae.InvoiceBaseController = Em.ObjectController.extend
  attachmentUploads: []

  actions:
    toggleOptionalLineItem: (lineItem) ->
      lineItem.set('optional', not lineItem.get('optional'))

    addLineItemAbove: (lineItem) ->
      currentRevision = @get "currentRevision"
      index = currentRevision.getLineItemIndex lineItem
      newLineItem = @get('content.transaction').createRecord Vosae.LineItem
      unless typeof index is `undefined`
        currentRevision.get('lineItems').insertAt index, newLineItem

    addLineItemBelow: (lineItem) ->
      currentRevision = @get "currentRevision"
      index = currentRevision.getLineItemIndex lineItem
      newLineItem = @get('content.transaction').createRecord Vosae.LineItem
      unless typeof index is `undefined`
        currentRevision.get('lineItems').insertAt index+1, newLineItem

    addLineItem: ->
      @get("currentRevision.lineItems").createRecord()

    deleteLineItem: (lineItem) ->
      Vosae.ConfirmPopup.open
        message: gettext 'Do you really want to delete this line?'
        callback: (opts, event) =>
          if opts.primary
            @get('currentRevision.lineItems').removeObject lineItem

    deleteAttachment: (attachment) ->
      Vosae.ConfirmPopup.open
        message: gettext 'Do you really want to delete this attachment?'
        callback: (opts, event) =>
          if opts.primary
            @get('attachments').removeObject attachment

    downloadAttachment: (attachment) ->
      $.fileDownload(Vosae.Config.APP_ENDPOINT + attachment.get('downloadLink'))
      return

    markAsState: (state) ->
      @get('content').markAsState state
      return

    downloadPdf: (language) ->
      @get('content').downloadPdf language
      return

    cancel: (invoiceBase) ->
      switch 
        when invoiceBase instanceof Vosae.Quotation
          if invoiceBase.get('id')
            @transitionToRoute 'quotation.show', @get('session.tenant'), invoiceBase
          else
            @transitionToRoute 'quotations.show', @get('session.tenant')
        when invoiceBase instanceof Vosae.Invoice
          if invoiceBase.get('id')
            @transitionToRoute 'invoice.show', @get('session.tenant'), invoiceBase
          else
            @transitionToRoute 'invoices.show', @get('session.tenant')
        when invoiceBase instanceof Vosae.PurchaseOrder
          if invoiceBase.get('id')
            @transitionToRoute 'purchaseOrder.show', @get('session.tenant'), invoiceBase
          else
            @transitionToRoute 'purchaseOrders.show', @get('session.tenant')
      return

    save: (invoiceBase) ->
      # Trigger errors
      errors = invoiceBase.getErrors()

      if errors.length
        alert(errors.join('\n'))
      else
        # Remove empty records
        senderAddress = invoiceBase.get('currentRevision.senderAddress')
        if senderAddress and senderAddress.recordIsEmpty()
          invoiceBase.get('currentRevision').set 'senderAddress', null

        billingAddress = invoiceBase.get('currentRevision.billingAddress')
        if billingAddress and billingAddress.recordIsEmpty()
          invoiceBase.get('currentRevision').set 'billingAddress', null

        deliveryAddress = invoiceBase.get('currentRevision.deliveryAddress')
        if deliveryAddress and deliveryAddress.recordIsEmpty()
          invoiceBase.get('currentRevision').set 'deliveryAddress', null

        if invoiceBase.get('currentRevision.lineItems')
          notEmptyItems = []
          invoiceBase.get('currentRevision.lineItems').forEach (item) ->
            if not item.recordIsEmpty()
              notEmptyItems.push item
          invoiceBase.set('currentRevision.lineItems.content', [])
          invoiceBase.get('currentRevision.lineItems').addObjects notEmptyItems

        invoiceBase.save().then (invoiceBase) =>
          switch 
            when invoiceBase instanceof Vosae.Quotation
              @transitionToRoute 'quotation.show', @get('session.tenant'), invoiceBase
            when invoiceBase instanceof Vosae.Invoice
              @transitionToRoute 'invoice.show', @get('session.tenant'), invoiceBase
            when invoiceBase instanceof Vosae.PurchaseOrder
              @transitionToRoute 'purchaseOrder.show', @get('session.tenant'), invoiceBase

    delete: (invoiceBase) ->
      message = switch 
        when invoiceBase instanceof Vosae.Quotation
          gettext("Do you really want to delete this quotation?")
        when invoiceBase instanceof Vosae.Invoice
          gettext("Do you really want to delete this invoice?")
        when invoiceBase instanceof Vosae.PurchaseOrder
          gettext("Do you really want to delete this purchase order?")

      Vosae.ConfirmPopup.open
        message: message
        callback: (opts, event) =>
          if opts.primary
            invoiceBase.delete()
            invoiceBase.save().then () =>
              switch
                when invoiceBase instanceof Vosae.Quotation
                  @transitionToRoute 'quotations.show', @get('session.tenant')
                when invoiceBase instanceof Vosae.Invoice
                  @transitionToRoute 'invoices.show', @get('session.tenant')
                when invoiceBase instanceof Vosae.PurchaseOrder
                  @transitionToRoute 'purchaseOrders.show', @get('session.tenant')


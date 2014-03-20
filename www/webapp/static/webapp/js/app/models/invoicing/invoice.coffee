###
  A data model that represents an invoice

  @class Invoice
  @extends Vosae.InvoiceBase
  @namespace Vosae
  @module Vosae
###

Vosae.Invoice = Vosae.InvoiceBase.extend
  state: DS.attr('string')
  paid: DS.attr('number')
  balance: DS.attr('number')
  hasTemporaryReference: DS.attr('boolean', defaultValue: true)
  payments: DS.hasMany('payment', async: true)

  displayState: (->
    # Returns the current state readable and translated.
    Vosae.Config.invoiceStatesChoices.findProperty('value', @get('state')).get('label')
  ).property('state')

  canAddPayment: (->
    # Determine if a `Payment` can be added to the `Invoice`.
    if @get('isSaving') or not @get('isPayable')
      return false
    if @get('balance') > 0
      uncommitedPayments = @get('payments').filterProperty('id', null)
      return true if uncommitedPayments.length is 0
    return false
  ).property('balance', 'payments.@each.id', 'isSaving')

  availableStates: (->
    # List the available states for the `Invoice`, depending of its current state.
    if @get('state') is "DRAFT"
      Vosae.Config.invoiceStatesChoices.filter (state) ->
        if ["REGISTERED"].contains state.get('value')
          state
    else if @get('state') is "REGISTERED"
      Vosae.Config.invoiceStatesChoices.filter (state) ->
        if ["CANCELLED"].contains state.get('value')
          state
    else if @get('state') is "OVERDUE"
      Vosae.Config.invoiceStatesChoices.filter (state) ->
        if ["CANCELLED"].contains state.get('value')
          state
    else if @get('state') is "PART_PAID"
      Vosae.Config.invoiceStatesChoices.filter (state) ->
        if ["CANCELLED"].contains state.get('value')
          state
    else if @get('state') is "PAID"
      Vosae.Config.invoiceStatesChoices.filter (state) ->
        if ["CANCELLED"].contains state.get('value')
          state
    else
      return []
  ).property('state')

  isModifiable: (->
    # True if the `Invoice` is still in a modifiable state.
    if ["DRAFT"].contains @get('state')
      return true
    return false
  ).property('state')

  isDeletable: (->
    # Determine if the `Invoice` could be deleted.
    if @get 'isModifiable'
      return true
    return false
  ).property('state')

  isCancelable: (->
    # True if the `Invoice` is in a cancelable state.
    # When cancelable, a credit note could be created.
    if ["REGISTERED", "OVERDUE", "PART_PAID", "PAID"].contains @get('state')
      return true
    return false
  ).property('state')

  isPayable: (->
    # True if the `Invoice` is in a payable state.
    if ["REGISTERED", "OVERDUE", "PART_PAID"].contains @get('state')
      return true
    return false
  ).property('state')

  isIssuable: (->
    # Determine if the `Quotation` could be sent.
    if ["DRAFT", "CANCELLED"].contains @get('state')
      return true
    return false
  ).property('state')

  isPayableOrPaid: (->
    # True if invoice is Payable or Paid
    if @get('isPayable') or @get('isPaid')
      return true
    return false
  ).property('isPayable', 'isPaid')

  isPaid: (->
    # True if the `Invoice` is paid.
    if @get('state') is "PAID"
      return true
    return false
  ).property('state')

  isDraft: (->
    # True if the `Invoice` is draft.
    if @get('state') is "DRAFT"
      return true
    return false
  ).property('state')

  isCancelled: (->
    # True if the `Invoice` is cancelled.
    if @get('state') is "CANCELLED"
      return true
    return false
  ).property('state')

  isInvoicable: (->
    # True if the `Invoice` is invoicable.
    unless @get('state')
      return false
    unless @get('state') is "DRAFT"
      return false
    if not @get('contact') and not @get('organization')
      return false
    if not @get('currentRevision.invoicingDate') or (not @get('currentRevision.dueDate') and not @get('currentRevision.customPaymentConditions'))
      return false
    if @get('currentRevision.lineItems.length') < 1
      return false
    return true
  ).property(
    'state',
    'contact',
    'organization',
    'currentRevision.invoicingDate',
    'currentRevision.dueDate',
    'currentRevision.customPaymentConditions',
    'currentRevision.lineItems',
    'currentRevision.lineItems.length'
  )

  invoiceCancel: (controller) ->
    # # Cancel the invoice and returns the associated credit note.
    # if @get('id') and @get('isCancelable')
    #   invoice = @
    #   invoice.set 'isCancelling', true
     
    #   store = @get('store')
    #   adapter = store.adapterForType invoice.constructor
    #   root = adapter.rootForType(invoice.constructor)
    #   serializer = adapter.get 'serializer'

    #   url = adapter.buildURL root, @get('id')
    #   url += "cancel/"

    #   adapter.ajax(url, "PUT").then((json) ->
    #     creditNoteId = serializer.deurlify json['credit_note_uri']
    #     if creditNoteId
    #       invoice.reload()
    #       Em.run @, ->
    #         Vosae.SuccessPopup.open
    #           message: gettext 'Your invoice has been cancelled'
    #         controller.transitionToRoute 'creditNote.show', controller.get('session.tenant'), store.find(Vosae.CreditNote, creditNoteId)
    #         invoice.set 'isCancelling', false
    #   ).then null, adapter.rejectionHandler

  getErrors: ->
    # Return an array of string that contains form validation errors 
    errors = []
    errors = errors.concat @get("currentRevision").getErrors("Invoice")
    return errors
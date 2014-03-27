###
  A base model that represents an invoice base

  @class InvoiceBase
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.InvoiceBase = Vosae.Model.extend
  reference: DS.attr('string')
  accountType: DS.attr('string')
  total: DS.attr('number')
  amount: DS.attr('number')
  # revisions: DS.hasMany('invoiceRevision')
  notes: DS.hasMany('invoiceNote')
  attachments: DS.hasMany('file', async: true)
  issuer: DS.belongsTo('user', async: true)
  organization: DS.belongsTo('organization', async: true)
  contact: DS.belongsTo('contact', async: true)
  currentRevision: DS.belongsTo('invoiceRevision')
  group: DS.belongsTo('invoiceBaseGroup', {async: true, inverse: null})

  isUploading: false
  isUpdatingState: false
  isGeneratingPdfState: false
  isQuotation: false
  isPurchaseOrder: false
  isInvoice: false
  isDownPaymentInvoice: false
  isCreditNote: false

  displayReceiver: (->
    # Return organization name or contact name.
    if @get('organization')
      return @get('organization.corporateName')
    else if @get('contact')
      return @get('contact.fullName')
    return ''
  ).property('organization.corporateName', 'contact.fullName')

  addAttachmentUrl: (->
    # Return the url to add attachment
    if @get("id")?
      adapter = @get('store').adapterFor 'invoiceBase'
      return adapter.buildURL(@constructor.typeKey, @get('id')) + "add_attachment/"
    return
  ).property("id")

  relatedColor: (->
    # Returns the related color of current instance,
    # green if `Invoice`, orange if `Quotation`. 
    if @get('isQuotation') or @get('isPurchaseOrder')
      return 'primary'
    return 'success'
  ).property()

  canHaveOptionalLineItems: (->
    if @get('isQuotation') or @get('isPurchaseOrder')
      return true
    return false
  ).property()

  markAsState: (state) ->
    # Set state of `InvoiceBase`.
    if state and @get('id') and not @get('isUpdatingState')
      @set 'isUpdatingState', true
      adapter = @get('store').adapterFor 'invoiceBase'

      # URL to update invoiceBase state
      url = adapter.buildURL @constructor.typeKey, @get('id')
      url += "mark_as_#{state.toLowerCase()}/"

      # Send request to API
      adapter.ajax(url, "PUT").then (json) =>
        @reload()
        @set 'isUpdatingState', false

  downloadPdf: (language) ->
    # if @get("currentRevision.pdf.#{language}")
    #   @get("currentRevision.pdf.#{language}").then (pdf) =>
    #     $.fileDownload(Vosae.Config.APP_ENDPOINT + pdf.get("downloadLink"))
    # else
    if not @get('isGeneratingPdfState')
      @set 'isGeneratingPdfState', true
      adapter = @get('store').adapterFor 'invoiceBase'
      
      # URL to update invoiceBase state
      url = adapter.buildURL @constructor.typeKey, @get('id')
      url += "generate_pdf/"

      # DIRTY 
      $.ajaxSetup()['headers']['X-Report-Language'] = language

      # Send request to API
      adapter.ajax(url, "GET").then (json) =>
        $.fileDownload Vosae.Config.APP_ENDPOINT + json.download_link
        @set 'isGeneratingPdfState', false
        @reload()

      # DIRTY
      delete $.ajaxSetup()['headers']['X-Report-Language']

  didCreate: ->
    message = switch
      when @ instanceof Vosae.Quotation
        gettext 'Your quotation has been successfully created'
      when @ instanceof Vosae.Invoice
        gettext 'Your invoice has been successfully created'
      when @ instanceof Vosae.CreditNote
        gettext 'Your credit note has been successfully created'
      when @ instanceof Vosae.DownPaymentInvoice
        gettext 'Your down payment invoice has been successfully created'
      when @ instanceof Vosae.PurchaseOrder
        gettext 'Your purchase order has been successfully created' 
    Vosae.SuccessPopup.open
      message: message

  didUpdate: ->
    message = switch
      when @ instanceof Vosae.Quotation
        gettext 'Your quotation has been successfully updated'
      when @ instanceof Vosae.Invoice
        gettext 'Your invoice has been successfully updated'
      when @ instanceof Vosae.CreditNote
        gettext 'Your credit note has been successfully updated'
      when @ instanceof Vosae.DownPaymentInvoice
        gettext 'Your down payment invoice has been successfully updated'
      when @ instanceof Vosae.PurchaseOrder
        gettext 'Your purchase order has been successfully updated'
    Vosae.SuccessPopup.open
      message: message

  didDelete: ->
    message = switch
      when @ instanceof Vosae.Quotation
        gettext 'Your quotation has been successfully deleted'
      when @ instanceof Vosae.Invoice
        gettext 'Your invoice has been successfully deleted'
      when @ instanceof Vosae.CreditNote
        gettext 'Your credit note has been successfully deleted'
      when @ instanceof Vosae.DownPaymentInvoice
        gettext 'Your down payment invoice has been successfully deleted'
      when @ instanceof Vosae.PurchaseOrder
        gettext 'Your purchase order has been successfully deleted'
    Vosae.SuccessPopup.open
      message: message

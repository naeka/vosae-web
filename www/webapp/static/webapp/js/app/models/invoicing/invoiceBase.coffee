###
  A base model that represents an invoice base

  @class InvoiceBase
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.InvoiceBase = Vosae.Model.extend
  ref: DS.attr('string')
  accountType: DS.attr('string')
  total: DS.attr('number')
  amount: DS.attr('number')
  notes: DS.hasMany('Vosae.InvoiceNote')
  attachments: DS.hasMany('Vosae.File')
  issuer: DS.belongsTo('Vosae.User')
  organization: DS.belongsTo('Vosae.Organization')
  contact: DS.belongsTo('Vosae.Contact')
  group: DS.belongsTo('Vosae.InvoiceBaseGroup', inverse: null)

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
      adapter = @get('store.adapter')
      root = adapter.rootForType(@constructor.toString())
      return adapter.buildURL(root, @get('id')) + "add_attachment/"
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
    if state and @get('id')
      invoiceBase = @
      invoiceBase.set 'isUpdatingState', true
     
      adapter = @get 'store.adapter'
      root = adapter.rootForType(invoiceBase.constructor.toString())
      
      # URL to update invoiceBase state
      url = adapter.buildURL root, @get('id')
      url += "mark_as_#{state.toLowerCase()}/"

      # Send request to API
      adapter.ajax(url, "PUT").then((json) ->
        Ember.run.next ->
          invoiceBase.reload()
          invoiceBase.set 'isUpdatingState', false
      ).then null, adapter.rejectionHandler

  downloadPdf: (language)->
    if @get("currentRevision.pdf.#{language}")
      pdf = @get("currentRevision.pdf.#{language}")
      if pdf.get("isLoaded")
        $.fileDownload(Vosae.Config.APP_ENDPOINT + pdf.get("downloadLink"))
      else
        pdf.one "didLoad", @, ->
          $.fileDownload(Vosae.Config.APP_ENDPOINT + pdf.get("downloadLink"))
    else
      invoiceBase = @
      invoiceBase.set 'isGeneratingPdfState', true
      adapter = @get 'store.adapter'
      root = adapter.rootForType(invoiceBase.constructor.toString())
      
      # URL to update invoiceBase state
      url = adapter.buildURL root, @get('id')
      url += "generate_pdf/"

      # DIRTY 
      $.ajaxSetup()['headers']['X-Report-Language'] = language

      # Send request to API
      adapter.ajax(url, "GET").then((json) ->
        Ember.run @, ->
          $.fileDownload(Vosae.Config.APP_ENDPOINT + json.download_link)
          invoiceBase.set 'isGeneratingPdfState', false
          invoiceBase.reload()
      ).then null, adapter.rejectionHandler

      # DIRTY
      delete $.ajaxSetup()['headers']['X-Report-Language']

  didCreate: ->
    message = switch @constructor.toString()
      when Vosae.Quotation.toString()
        gettext 'Your quotation has been successfully created'
      when Vosae.Invoice.toString()
        gettext 'Your invoice has been successfully created'
      when Vosae.CreditNote.toString()
        gettext 'Your credit note has been successfully created'
      when Vosae.DownPaymentInvoice.toString()
        gettext 'Your down payment invoice has been successfully created'
      when Vosae.PurchaseOrder.toString()
        gettext 'Your purchase order has been successfully created' 
    Vosae.SuccessPopupComponent.open
      message: message

  didUpdate: ->
    message = switch @constructor.toString()
      when Vosae.Quotation.toString()
        gettext 'Your quotation has been successfully updated'
      when Vosae.Invoice.toString()
        gettext 'Your invoice has been successfully updated'
      when Vosae.CreditNote.toString()
        gettext 'Your credit note has been successfully updated'
      when Vosae.DownPaymentInvoice.toString()
        gettext 'Your down payment invoice has been successfully updated'
      when Vosae.PurchaseOrder.toString()
        gettext 'Your purchase order has been successfully updated'
    Vosae.SuccessPopupComponent.open
      message: message

  didDelete: ->
    message = switch @constructor.toString()
      when Vosae.Quotation.toString()
        gettext 'Your quotation has been successfully deleted'
      when Vosae.Invoice.toString()
        gettext 'Your invoice has been successfully deleted'
      when Vosae.CreditNote.toString()
        gettext 'Your credit note has been successfully deleted'
      when Vosae.DownPaymentInvoice.toString()
        gettext 'Your down payment invoice has been successfully deleted'
      when Vosae.PurchaseOrder.toString()
        gettext 'Your purchase order has been successfully deleted'
    Vosae.SuccessPopupComponent.open
      message: message

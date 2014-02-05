Vosae.InvoiceBase = DS.Model.extend
  ref: DS.attr('string')
  accountType: DS.attr('string')
  total: DS.attr('number')
  amount: DS.attr('number')
  # revisions: DS.hasMany('Vosae.InvoiceRevision')
  notes: DS.hasMany('Vosae.InvoiceNote')
  attachments: DS.hasMany('Vosae.File')
  issuer: DS.belongsTo('Vosae.User')
  organization: DS.belongsTo('Vosae.Organization')
  contact: DS.belongsTo('Vosae.Contact')
  currentRevision: DS.belongsTo('Vosae.InvoiceRevision')
  group: DS.belongsTo('Vosae.InvoiceBaseGroup', inverse: null)

  isUploading: false
  isUpdatingState: false
  isGeneratingPdfState: false

  displayTenant: (->
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

  isInvoice: (->
    # True if `InvoiceBase` is an `Invoice`.
    if @constructor.toString() is Vosae.Invoice.toString()
      return true
    return false
  ).property()

  isQuotation: (->
    # True if `InvoiceBase` is an `Quotation`.
    if @constructor.toString() is Vosae.Quotation.toString()
      return true
    return false
  ).property()

  isCreditNote: (->
    # True if `InvoiceBase` is a `CreditNote`.
    if @constructor.toString() is Vosae.CreditNote.toString()
      return true
    return false
  ).property()

  isPurchaseOrder: (->
    # True if `InvoiceBase` is a `PurchaseOrder`.
    if @constructor.toString() is Vosae.PurchaseOrder.toString()
      return true
    return false
  ).property()

  relatedColor: (->
    # Returns the related color of current instance,
    # green if `Invoice`, orange if `Quotation`. 
    if @get('isQuotation') or @get('isPurchaseOrder')
      return 'primary'
    return 'success'
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
        $.fileDownload(APP_ENDPOINT + pdf.get("downloadLink"))
      else
        pdf.one "didLoad", @, ->
          $.fileDownload(APP_ENDPOINT + pdf.get("downloadLink"))
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
          $.fileDownload(APP_ENDPOINT + json.download_link)
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

# Vosae.InvoiceBase.reopenClass
#   inverseFor: (name) ->
#     if @metaForProperty(name).options.inverse is null
#       return null 
#     this._super.apply this, arguments
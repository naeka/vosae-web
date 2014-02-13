Vosae.LazyContactResource = Ember.Mixin.create
  resource: (->
    if @_data.contact
      dict =
        type: "Vosae.Contact"
        id: @_data.contact.id
      return dict
    return null
  ).property('contact')

Vosae.LazyOrganizationResource = Ember.Mixin.create
  resource: (->
    if @_data.organization
      dict =
        type: "Vosae.Organization"
        id: @_data.organization.id
      return dict
    return null
  ).property('organization')

Vosae.LazyInvoiceResource = Ember.Mixin.create
  invoiceResource: (->
    if @_data.invoice
      dict =
        type: "Vosae.Invoice"
        id: @_data.invoice.id
      return dict
    return null
  ).property('invoice')

Vosae.LazyQuotationResource = Ember.Mixin.create
  quotationResource: (->
    if @_data.quotation
      dict =
        type: "Vosae.Quotation"
        id: @_data.quotation.id
      return dict
    return null
  ).property('quotation')

Vosae.LazyDownPaymentInvoiceResource = Ember.Mixin.create
  resource: (->
    if @_data.downPaymentInvoice
      dict =
        type: "Vosae.DownPaymentInvoice"
        id: @_data.downPaymentInvoice.id
      return dict
    return null
  ).property('downPaymentInvoice')

Vosae.LazyCreditNoteResource = Ember.Mixin.create
  resource: (->
    if @_data.creditNote
      dict =
        type: "Vosae.CreditNote"
        id: @_data.creditNote.id
      return dict
    return null
  ).property('creditNote')

Vosae.LazyEventReminderResource = Ember.Mixin.create
  resource: (->
    if @_data.vosaeEvent
      dict =
        type: "Vosae.VosaeEvent"
        id: @_data.vosaeEvent.id
      return dict
    return null
  ).property('vosaeEvent')
###
  This mixin check if a belongsTo relationship exist without creating a `GET` request

  @class LazyContactResourceMixin 
  @extends Ember.Mixin
  @namespace Vosae
  @module Vosae
###

Vosae.LazyContactResourceMixin = Ember.Mixin.create
  resource: (->
    if @_data.contact
      dict =
        type: "Vosae.Contact"
        id: @_data.contact.id
      return dict
    return null
  ).property('contact')


###
  This mixin check if a belongsTo relationship exist without creating a `GET` request

  @class LazyOrganizationResourceMixin 
  @extends Ember.Mixin
  @namespace Vosae
  @module Vosae
###

Vosae.LazyOrganizationResourceMixin = Ember.Mixin.create
  resource: (->
    if @_data.organization
      dict =
        type: "Vosae.Organization"
        id: @_data.organization.id
      return dict
    return null
  ).property('organization')


###
  This mixin check if a belongsTo relationship exist without creating a `GET` request

  @class LazyInvoiceResourceMixin 
  @extends Ember.Mixin
  @namespace Vosae
  @module Vosae
###

Vosae.LazyInvoiceResourceMixin = Ember.Mixin.create
  invoiceResource: (->
    if @_data.invoice
      dict =
        type: "Vosae.Invoice"
        id: @_data.invoice.id
      return dict
    return null
  ).property('invoice')


###
  This mixin check if a belongsTo relationship exist without creating a `GET` request

  @class LazyQuotationResourceMixin 
  @extends Ember.Mixin
  @namespace Vosae
  @module Vosae
###

Vosae.LazyQuotationResourceMixin = Ember.Mixin.create
  quotationResource: (->
    if @_data.quotation
      dict =
        type: "Vosae.Quotation"
        id: @_data.quotation.id
      return dict
    return null
  ).property('quotation')


###
  This mixin check if a belongsTo relationship exist without creating a `GET` request

  @class LazyDownPaymentInvoiceResourceMixin 
  @extends Ember.Mixin
  @namespace Vosae
  @module Vosae
###

Vosae.LazyDownPaymentInvoiceResourceMixin = Ember.Mixin.create
  resource: (->
    if @_data.downPaymentInvoice
      dict =
        type: "Vosae.DownPaymentInvoice"
        id: @_data.downPaymentInvoice.id
      return dict
    return null
  ).property('downPaymentInvoice')


###
  This mixin check if a belongsTo relationship exist without creating a `GET` request

  @class LazyCreditNoteResourceMixin 
  @extends Ember.Mixin
  @namespace Vosae
  @module Vosae
###

Vosae.LazyCreditNoteResourceMixin = Ember.Mixin.create
  resource: (->
    if @_data.creditNote
      dict =
        type: "Vosae.CreditNote"
        id: @_data.creditNote.id
      return dict
    return null
  ).property('creditNote')


###
  This mixin check if a belongsTo relationship exist without creating a `GET` request

  @class LazyEventReminderResourceMixin 
  @extends Ember.Mixin
  @namespace Vosae
  @module Vosae
###

Vosae.LazyEventReminderResourceMixin = Ember.Mixin.create
  resource: (->
    if @_data.vosaeEvent
      dict =
        type: "Vosae.VosaeEvent"
        id: @_data.vosaeEvent.id
      return dict
    return null
  ).property('vosaeEvent')
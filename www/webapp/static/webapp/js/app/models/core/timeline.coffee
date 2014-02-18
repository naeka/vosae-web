###
  A base model that represents a timeline entry

  @class Timeline
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.Timeline = Vosae.Model.extend
  datetime: DS.attr('datetime')
  created: DS.attr('boolean')
  module: DS.attr('string')
  issuerName: DS.attr('string')
  issuer: DS.belongsTo('Vosae.User')

  dateFormated: (->
    moment(@.get('datetime')).format "LL"
  ).property('datetime')

  displayView: Em.View.extend
    templateName: 'timelineEntry/base'


###
  A data model that represents a timeline entry of type contact saved

  @class ContactSavedTE
  @extends Vosae.Timeline
  @uses Vosae.LazyContactResourceMixin
  @namespace Vosae
  @module Vosae
###

Vosae.ContactSavedTE = Vosae.Timeline.extend Vosae.LazyContactResourceMixin,
  contactName: DS.attr('string')
  contact: DS.belongsTo('Vosae.Contact')

  displayView: Em.View.extend
    templateName: 'timelineEntry/contactSaved'


###
  A data model that represents a timeline entry of type organization saved

  @class OrganizationSavedTE
  @extends Vosae.Timeline
  @uses Vosae.LazyOrganizationResourceMixin
  @namespace Vosae
  @module Vosae
###

Vosae.OrganizationSavedTE = Vosae.Timeline.extend Vosae.LazyOrganizationResourceMixin,
  organizationName: DS.attr('string')
  organization: DS.belongsTo('Vosae.Organization')

  displayView: Em.View.extend
    templateName: 'timelineEntry/organizationSaved'


###
  A data model that represents a timeline entry of type quotation saved

  @class QuotationSavedTE
  @extends Vosae.Timeline
  @uses Vosae.LazyQuotationResourceMixin
  @namespace Vosae
  @module Vosae
###

Vosae.QuotationSavedTE = Vosae.Timeline.extend Vosae.LazyQuotationResourceMixin,
  customerDisplay: DS.attr('string')
  quotationReference: DS.attr('string')
  quotation: DS.belongsTo('Vosae.Quotation')

  displayView: Em.View.extend
    templateName: 'timelineEntry/quotationSaved'


###
  A data model that represents a timeline entry of type invoice saved

  @class InvoiceSavedTE
  @extends Vosae.Timeline
  @uses Vosae.LazyInvoiceResourceMixin
  @namespace Vosae
  @module Vosae
###

Vosae.InvoiceSavedTE = Vosae.Timeline.extend Vosae.LazyInvoiceResourceMixin,
  customerDisplay: DS.attr('string')
  invoiceReference: DS.attr('string')
  invoice: DS.belongsTo('Vosae.Invoice')
  invoiceHasTemporaryReference: DS.attr('boolean')

  displayView: Em.View.extend
    templateName: 'timelineEntry/invoiceSaved'


###
  A data model that represents a timeline entry of type downpayment invoice saved

  @class DownPaymentInvoiceSavedTE
  @extends Vosae.Timeline
  @uses Vosae.LazyDownPaymentInvoiceResourceMixin
  @namespace Vosae
  @module Vosae
###

Vosae.DownPaymentInvoiceSavedTE = Vosae.Timeline.extend Vosae.LazyDownPaymentInvoiceResourceMixin,
  customerDisplay: DS.attr('string')
  downPaymentInvoiceReference: DS.attr('string')
  downPaymentInvoice: DS.belongsTo('Vosae.DownPaymentInvoice')

  displayView: Em.View.extend
    templateName: 'timelineEntry/downPaymentInvoiceSaved'


###
  A data model that represents a timeline entry of type credit note saved

  @class CreditNoteSavedTE
  @extends Vosae.Timeline
  @uses Vosae.LazyCreditNoteResourceMixin
  @namespace Vosae
  @module Vosae
###

Vosae.CreditNoteSavedTE = Vosae.Timeline.extend Vosae.LazyCreditNoteResourceMixin,
  customerDisplay: DS.attr('string')
  creditNoteReference: DS.attr('string')
  creditNote: DS.belongsTo('Vosae.CreditNote')

  displayView: Em.View.extend
    templateName: 'timelineEntry/creditNoteSaved'


###
  A data model that represents a timeline entry of type quotation changed state

  @class QuotationChangedStateTE
  @extends Vosae.Timeline
  @uses Vosae.LazyQuotationResourceMixin
  @namespace Vosae
  @module Vosae
###

Vosae.QuotationChangedStateTE = Vosae.Timeline.extend Vosae.LazyQuotationResourceMixin,
  previousState: DS.attr('string')
  newState: DS.attr('string')
  quotationReference: DS.attr('string')
  quotation: DS.belongsTo('Vosae.Quotation')

  displayView: Em.View.extend
    templateName: 'timelineEntry/quotationChangedState'


###
  A data model that represents a timeline entry of type invoice changed state

  @class InvoiceChangedStateTE
  @extends Vosae.Timeline
  @uses Vosae.LazyInvoiceResourceMixin
  @namespace Vosae
  @module Vosae
###

Vosae.InvoiceChangedStateTE = Vosae.Timeline.extend Vosae.LazyInvoiceResourceMixin,
  previousState: DS.attr('string')
  newState: DS.attr('string')
  invoiceReference: DS.attr('string')
  invoice: DS.belongsTo('Vosae.Invoice')

  displayView: Em.View.extend
    templateName: 'timelineEntry/invoiceChangedState'


###
  A data model that represents a timeline entry of type downpayment invoice changed state

  @class DownPaymentInvoiceChangedStateTE
  @extends Vosae.Timeline
  @uses Vosae.LazyDownPaymentInvoiceResourceMixin
  @namespace Vosae
  @module Vosae
###

Vosae.DownPaymentInvoiceChangedStateTE = Vosae.Timeline.extend Vosae.LazyDownPaymentInvoiceResourceMixin,
  previousState: DS.attr('string')
  newState: DS.attr('string')
  downPaymentInvoiceReference: DS.attr('string')
  downPaymentInvoice: DS.belongsTo('Vosae.DownPaymentInvoice')

  displayView: Em.View.extend
    templateName: 'timelineEntry/downPaymentInvoiceChangedState'


###
  A data model that represents a timeline entry of type contact note changed state

  @class CreditNoteChangedStateTE
  @extends Vosae.Timeline
  @uses Vosae.LazyCreditNoteResourceMixin
  @namespace Vosae
  @module Vosae
###

Vosae.CreditNoteChangedStateTE = Vosae.Timeline.extend Vosae.LazyCreditNoteResourceMixin,
  previousState: DS.attr('string')
  newState: DS.attr('string')
  creditNoteReference: DS.attr('string')
  creditNote: DS.belongsTo('Vosae.CreditNote')

  displayView: Em.View.extend
    templateName: 'timelineEntry/creditNoteChangedState'


###
  A data model that represents a timeline entry of type quotation added attachment

  @class QuotationAddedAttachmentTE
  @extends Vosae.Timeline
  @uses Vosae.LazyQuotationResourceMixin
  @namespace Vosae
  @module Vosae
###

Vosae.QuotationAddedAttachmentTE = Vosae.Timeline.extend Vosae.LazyQuotationResourceMixin,
  vosaeFile: DS.belongsTo('Vosae.File')
  quotationReference: DS.attr('string')
  quotation: DS.belongsTo('Vosae.Quotation')

  displayView: Em.View.extend
    templateName: 'timelineEntry/quotationAddedAttachment'


###
  A data model that represents a timeline entry of type invoice added attachment

  @class InvoiceAddedAttachmentTE
  @extends Vosae.Timeline
  @uses Vosae.LazyInvoiceResourceMixin
  @namespace Vosae
  @module Vosae
###

Vosae.InvoiceAddedAttachmentTE = Vosae.Timeline.extend Vosae.LazyInvoiceResourceMixin,
  vosaeFile: DS.belongsTo('Vosae.File')
  invoiceReference: DS.attr('string')
  invoice: DS.belongsTo('Vosae.Invoice')

  displayView: Em.View.extend
    templateName: 'timelineEntry/invoiceAddedAttachment'


###
  A data model that represents a timeline entry of type downpayment invoice added attachment

  @class DownPaymentInvoiceAddedAttachmentTE
  @extends Vosae.Timeline
  @uses Vosae.LazyDownPaymentInvoiceResourceMixin
  @namespace Vosae
  @module Vosae
###

Vosae.DownPaymentInvoiceAddedAttachmentTE = Vosae.Timeline.extend Vosae.LazyDownPaymentInvoiceResourceMixin,
  vosaeFile: DS.belongsTo('Vosae.File')
  downPaymentInvoiceReference: DS.attr('string')
  downPaymentInvoice: DS.belongsTo('Vosae.DownPaymentInvoice')

  displayView: Em.View.extend
    templateName: 'timelineEntry/downPaymentInvoiceAddedAttachment'


###
  A data model that represents a timeline entry of type credit note added attachment

  @class CreditNoteAddedAttachmentTE
  @extends Vosae.Timeline
  @uses Vosae.LazyCreditNoteResourceMixin
  @namespace Vosae
  @module Vosae
###

Vosae.CreditNoteAddedAttachmentTE = Vosae.Timeline.extend Vosae.LazyCreditNoteResourceMixin,
  vosaeFile: DS.belongsTo('Vosae.File')
  creditNoteReference: DS.attr('string')
  creditNote: DS.belongsTo('Vosae.CreditNote')

  displayView: Em.View.extend
    templateName: 'timelineEntry/creditNoteAddedAttachment'


###
  A data model that represents a timeline entry of type quotation make invoice

  @class QuotationMakeInvoiceTE
  @extends Vosae.Timeline
  @uses Vosae.LazyQuotationResourceMixin, Vosae.LazyInvoiceResourceMixin
  @namespace Vosae
  @module Vosae
###

Vosae.QuotationMakeInvoiceTE = Vosae.Timeline.extend Vosae.LazyQuotationResourceMixin, Vosae.LazyInvoiceResourceMixin,
  customerDisplay: DS.attr('string')
  quotationReference: DS.attr('string')
  quotation: DS.belongsTo('Vosae.Quotation')
  invoiceReference: DS.attr('string')
  invoiceHasTemporaryReference: DS.attr('boolean')
  invoice: DS.belongsTo('Vosae.Invoice')

  displayView: Em.View.extend
    templateName: 'timelineEntry/quotationMakeInvoice'


###
  A data model that represents a timeline entry of type quotation make downpayment invoice

  @class QuotationMakeDownPaymentInvoiceTE
  @extends Vosae.Timeline
  @uses Vosae.LazyQuotationResourceMixin
  @namespace Vosae
  @module Vosae
###

Vosae.QuotationMakeDownPaymentInvoiceTE = Vosae.Timeline.extend Vosae.LazyQuotationResourceMixin,
  quotationReference: DS.attr('string')
  quotation: DS.belongsTo('Vosae.Quotation')
  downPaymentInvoice: DS.belongsTo('Vosae.DownPaymentInvoice')

  displayView: Em.View.extend
    templateName: 'timelineEntry/quotationMakeDownPaymentInvoice'


###
  A data model that represents a timeline entry of type invoice cancelled

  @class InvoiceCancelledTE
  @extends Vosae.Timeline
  @uses Vosae.LazyInvoiceResourceMixin
  @namespace Vosae
  @module Vosae
###

Vosae.InvoiceCancelledTE = Vosae.Timeline.extend Vosae.LazyInvoiceResourceMixin,
  invoiceReference: DS.attr('string')
  invoice: DS.belongsTo('Vosae.Invoice')
  creditNote: DS.belongsTo('Vosae.CreditNote')

  displayView: Em.View.extend
    templateName: 'timelineEntry/invoiceCancelled'


###
  A data model that represents a timeline entry of type downpayment invoice cancelled

  @class DownPaymentInvoiceCancelledTE
  @extends Vosae.Timeline
  @uses Vosae.LazyDownPaymentInvoiceResourceMixin
  @namespace Vosae
  @module Vosae
###

Vosae.DownPaymentInvoiceCancelledTE = Vosae.Timeline.extend Vosae.LazyDownPaymentInvoiceResourceMixin,
  downPaymentInvoiceReference: DS.attr('string')
  downPaymentInvoice: DS.belongsTo('Vosae.DownPaymentInvoice')
  creditNote: DS.belongsTo('Vosae.CreditNote')

  displayView: Em.View.extend
    templateName: 'timelineEntry/downPaymentInvoiceCancelled'
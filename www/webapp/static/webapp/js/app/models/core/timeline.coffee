Vosae.Timeline = DS.Model.extend
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

Vosae.ContactSavedTE = Vosae.Timeline.extend Vosae.LazyContactResource,
  contactName: DS.attr('string')
  contact: DS.belongsTo('Vosae.Contact')

  displayView: Em.View.extend
    templateName: 'timelineEntry/contactSaved'

Vosae.OrganizationSavedTE = Vosae.Timeline.extend Vosae.LazyOrganizationResource,
  organizationName: DS.attr('string')
  organization: DS.belongsTo('Vosae.Organization')

  displayView: Em.View.extend
    templateName: 'timelineEntry/organizationSaved'

Vosae.QuotationSavedTE = Vosae.Timeline.extend Vosae.LazyQuotationResource,
  customerDisplay: DS.attr('string')
  quotationReference: DS.attr('string')
  quotation: DS.belongsTo('Vosae.Quotation')

  displayView: Em.View.extend
    templateName: 'timelineEntry/quotationSaved'

Vosae.InvoiceSavedTE = Vosae.Timeline.extend Vosae.LazyInvoiceResource,
  customerDisplay: DS.attr('string')
  invoiceReference: DS.attr('string')
  invoice: DS.belongsTo('Vosae.Invoice')
  invoiceHasTemporaryReference: DS.attr('boolean')

  displayView: Em.View.extend
    templateName: 'timelineEntry/invoiceSaved'

Vosae.DownPaymentInvoiceSavedTE = Vosae.Timeline.extend Vosae.LazyDownPaymentInvoiceResource,
  customerDisplay: DS.attr('string')
  downPaymentInvoiceReference: DS.attr('string')
  downPaymentInvoice: DS.belongsTo('Vosae.DownPaymentInvoice')

  displayView: Em.View.extend
    templateName: 'timelineEntry/downPaymentInvoiceSaved'

Vosae.CreditNoteSavedTE = Vosae.Timeline.extend Vosae.LazyCreditNoteResource,
  customerDisplay: DS.attr('string')
  creditNoteReference: DS.attr('string')
  creditNote: DS.belongsTo('Vosae.CreditNote')

  displayView: Em.View.extend
    templateName: 'timelineEntry/creditNoteSaved'

Vosae.QuotationChangedStateTE = Vosae.Timeline.extend Vosae.LazyQuotationResource,
  previousState: DS.attr('string')
  newState: DS.attr('string')
  quotationReference: DS.attr('string')
  quotation: DS.belongsTo('Vosae.Quotation')

  displayView: Em.View.extend
    templateName: 'timelineEntry/quotationChangedState'

Vosae.InvoiceChangedStateTE = Vosae.Timeline.extend Vosae.LazyInvoiceResource,
  previousState: DS.attr('string')
  newState: DS.attr('string')
  invoiceReference: DS.attr('string')
  invoice: DS.belongsTo('Vosae.Invoice')

  displayView: Em.View.extend
    templateName: 'timelineEntry/invoiceChangedState'

Vosae.DownPaymentInvoiceChangedStateTE = Vosae.Timeline.extend Vosae.LazyDownPaymentInvoiceResource,
  previousState: DS.attr('string')
  newState: DS.attr('string')
  downPaymentInvoiceReference: DS.attr('string')
  downPaymentInvoice: DS.belongsTo('Vosae.DownPaymentInvoice')

  displayView: Em.View.extend
    templateName: 'timelineEntry/downPaymentInvoiceChangedState'

Vosae.CreditNoteChangedStateTE = Vosae.Timeline.extend Vosae.LazyCreditNoteResource,
  previousState: DS.attr('string')
  newState: DS.attr('string')
  creditNoteReference: DS.attr('string')
  creditNote: DS.belongsTo('Vosae.CreditNote')

  displayView: Em.View.extend
    templateName: 'timelineEntry/creditNoteChangedState'

Vosae.QuotationAddedAttachmentTE = Vosae.Timeline.extend Vosae.LazyQuotationResource,
  vosaeFile: DS.belongsTo('Vosae.File')
  quotationReference: DS.attr('string')
  quotation: DS.belongsTo('Vosae.Quotation')

  displayView: Em.View.extend
    templateName: 'timelineEntry/quotationAddedAttachment'

Vosae.InvoiceAddedAttachmentTE = Vosae.Timeline.extend Vosae.LazyInvoiceResource,
  vosaeFile: DS.belongsTo('Vosae.File')
  invoiceReference: DS.attr('string')
  invoice: DS.belongsTo('Vosae.Invoice')

  displayView: Em.View.extend
    templateName: 'timelineEntry/invoiceAddedAttachment'

Vosae.DownPaymentInvoiceAddedAttachmentTE = Vosae.Timeline.extend Vosae.LazyDownPaymentInvoiceResource,
  vosaeFile: DS.belongsTo('Vosae.File')
  downPaymentInvoiceReference: DS.attr('string')
  downPaymentInvoice: DS.belongsTo('Vosae.DownPaymentInvoice')

  displayView: Em.View.extend
    templateName: 'timelineEntry/downPaymentInvoiceAddedAttachment'

Vosae.CreditNoteAddedAttachmentTE = Vosae.Timeline.extend Vosae.LazyCreditNoteResource,
  vosaeFile: DS.belongsTo('Vosae.File')
  creditNoteReference: DS.attr('string')
  creditNote: DS.belongsTo('Vosae.CreditNote')

  displayView: Em.View.extend
    templateName: 'timelineEntry/creditNoteAddedAttachment'

Vosae.QuotationMakeInvoiceTE = Vosae.Timeline.extend Vosae.LazyQuotationResource, Vosae.LazyInvoiceResource,
  customerDisplay: DS.attr('string')
  quotationReference: DS.attr('string')
  quotation: DS.belongsTo('Vosae.Quotation')
  invoiceReference: DS.attr('string')
  invoiceHasTemporaryReference: DS.attr('boolean')
  invoice: DS.belongsTo('Vosae.Invoice')

  displayView: Em.View.extend
    templateName: 'timelineEntry/quotationMakeInvoice'

Vosae.QuotationMakeDownPaymentInvoiceTE = Vosae.Timeline.extend Vosae.LazyQuotationResource,
  quotationReference: DS.attr('string')
  quotation: DS.belongsTo('Vosae.Quotation')
  downPaymentInvoice: DS.belongsTo('Vosae.DownPaymentInvoice')

  displayView: Em.View.extend
    templateName: 'timelineEntry/quotationMakeDownPaymentInvoice'

Vosae.InvoiceCancelledTE = Vosae.Timeline.extend Vosae.LazyInvoiceResource,
  invoiceReference: DS.attr('string')
  invoice: DS.belongsTo('Vosae.Invoice')
  creditNote: DS.belongsTo('Vosae.CreditNote')

  displayView: Em.View.extend
    templateName: 'timelineEntry/invoiceCancelled'

Vosae.DownPaymentInvoiceCancelledTE = Vosae.Timeline.extend Vosae.LazyDownPaymentInvoiceResource,
  downPaymentInvoiceReference: DS.attr('string')
  downPaymentInvoice: DS.belongsTo('Vosae.DownPaymentInvoice')
  creditNote: DS.belongsTo('Vosae.CreditNote')

  displayView: Em.View.extend
    templateName: 'timelineEntry/downPaymentInvoiceCancelled'
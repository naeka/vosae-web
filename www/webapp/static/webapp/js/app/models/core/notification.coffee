Vosae.Notification = DS.Model.extend
  read: DS.attr('boolean')
  sentAt: DS.attr('datetime')

  displayView: Em.View.extend
    templateName: 'notificationEntry/base'

  markAsRead: ->
    @set('read', true)

    # Get record and manually update his current state
    record = @
    record.set 'currentState', DS.RootState.loaded.updated.inFlight
    
    # Get store and adapter instances
    store = @get('store')
    adapter = store.get('adapter')
    
    # Generate url used to mark notification as read
    url = adapter.buildURL('notification', @get('id'))
    url = url + 'mark_as_read/'

    # Then send request to API
    adapter.ajax url, "PUT",
      success: (json) ->
        Ember.run @, ->
          @didSaveRecord store, Vosae.Notification, record, json 


Vosae.ContactSavedNE = Vosae.Notification.extend Vosae.LazyContactResource,
  contactName: DS.attr('string')
  contact: DS.belongsTo('Vosae.Contact')

  displayView: Em.View.extend
    templateName: 'notificationEntry/contactSaved'

  module: (->
    "contact"
  ).property()

Vosae.OrganizationSavedNE = Vosae.Notification.extend Vosae.LazyOrganizationResource,
  organizationName: DS.attr('string')
  organization: DS.belongsTo('Vosae.Organization')

  displayView: Em.View.extend
    templateName: 'notificationEntry/organizationSaved'

  module: (->
    "contact"
  ).property()

Vosae.QuotationSavedNE = Vosae.Notification.extend Vosae.LazyQuotationResource,
  customerDisplay: DS.attr('string')
  quotationReference: DS.attr('string')
  quotation: DS.belongsTo('Vosae.Quotation')

  displayView: Em.View.extend
    templateName: 'notificationEntry/quotationSaved'

  module: (->
    "invoicing"
  ).property()

Vosae.InvoiceSavedNE = Vosae.Notification.extend Vosae.LazyInvoiceResource,
  customerDisplay: DS.attr('string')
  invoiceReference: DS.attr('string')
  invoice: DS.belongsTo('Vosae.Invoice')
  invoiceHasTemporaryReference: DS.attr('boolean')

  displayView: Em.View.extend
    templateName: 'notificationEntry/invoiceSaved'

  module: (->
    "invoicing"
  ).property()

Vosae.DownPaymentInvoiceSavedNE = Vosae.Notification.extend Vosae.LazyDownPaymentInvoiceResource,
  customerDisplay: DS.attr('string')
  downPaymentInvoiceReference: DS.attr('string')
  downPaymentInvoice: DS.belongsTo('Vosae.DownPaymentInvoice')

  displayView: Em.View.extend
    templateName: 'notificationEntry/downPaymentInvoiceSaved'

  module: (->
    "invoicing"
  ).property()

Vosae.CreditNoteSavedNE = Vosae.Notification.extend Vosae.LazyCreditNoteResource,
  customerDisplay: DS.attr('string')
  creditNoteReference: DS.attr('string')
  creditNote: DS.belongsTo('Vosae.CreditNote')

  displayView: Em.View.extend
    templateName: 'notificationEntry/creditNoteSaved'

  module: (->
    "invoicing"
  ).property()

Vosae.EventReminderNE = Vosae.Notification.extend Vosae.LazyEventReminderResource,
  occursAt: DS.attr('datetime')
  summary: DS.attr('string')
  vosaeEvent: DS.belongsTo('Vosae.VosaeEvent')

  displayView: Em.View.extend
    templateName: 'notificationEntry/eventReminder'

  module: (->
    "organizer"
  ).property()

  inFuture: (->
    if @get('occursAt') > new Date()
      return true
    return false
  ).property('occursAt')
DS.Model.reopen
  becameError: ->
    message = "An error happened on #{@toString()}"
    Vosae.ErrorPopupComponent.open
      message: message

  resetErrors: ->
    # Remove errors
    if !Ember.isNone @get('errors')
      @set 'errors', null
    # Flag record has valid
    if !@get 'isValid'
      @send 'becameValid'

  pushError: (key, error) ->
    if Ember.isNone @get('errors')
      @set 'errors', {}
    if Ember.isNone @get('errors')[key]
      @get('errors')[key] = []
    if !Ember.isNone error
      @get('errors')[key].push error
      if @get 'isValid'
        @send 'becameInvalid'

#   becameInvalid: ->
#     message = "#{@toString()} became invalid because of: #{@get('errors')}"
#     Vosae.ErrorPopupComponent.open
#       message: message
#     @send('becameValid')

# Imports models
require 'models/core/tenant'
require 'models/core/file'
require 'models/core/group'
require 'models/core/notification'
require 'models/core/permission'
require 'models/core/registrationInfo'
require 'models/core/reportSettings'
require 'models/core/timeline'
require 'models/core/user'
require 'models/core/userSettings'

require 'models/settings/apiKey'
require 'models/settings/tenantSettings'
require 'models/settings/storageQuotasSettings'
require 'models/settings/coreSettings'
require 'models/settings/invoicingSettings'
require 'models/settings/invoicingNumberingSettings'

require 'models/contacts/email'
require 'models/contacts/phone'
require 'models/contacts/address'
require 'models/contacts/entity'
require 'models/contacts/organization'
require 'models/contacts/contact'
require 'models/contacts/contactGroup'

require 'models/invoicing/currency'
require 'models/invoicing/exchangeRate'
require 'models/invoicing/tax'
require 'models/invoicing/invoiceNote'
require 'models/invoicing/payment'
require 'models/invoicing/invoiceRevision'
require 'models/invoicing/lineItem'
require 'models/invoicing/item'
require 'models/invoicing/invoiceBase'
require 'models/invoicing/quotation'
require 'models/invoicing/invoice'
require 'models/invoicing/downPaymentInvoice'
require 'models/invoicing/creditNote'
require 'models/invoicing/invoiceBaseGroup'
require 'models/invoicing/purchaseOrder'

require 'models/organizer/calendar'
require 'models/organizer/attendee'
require 'models/organizer/calendar'
require 'models/organizer/calendarAcl'
require 'models/organizer/calendarList'
require 'models/organizer/event'
require 'models/organizer/eventDateTime'
require 'models/organizer/eventOccurrence'
require 'models/organizer/reminderSettings'
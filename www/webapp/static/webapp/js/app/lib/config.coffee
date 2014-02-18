###
  General configuration for Vosae application

  @class Config
  @namespace Vosae
  @module Vosae
###

Vosae.Config =

  AUTH_USER: AUTH_USER
  LANGUAGE: LANGUAGE
  APP_ENDPOINT: APP_ENDPOINT
  API_NAMESPACE: "api/v1"
  PUSHER_KEY: PUSHER_KEY
  PUSHER_USER_CHANNEL: null
  PUSHER_CLUSTER: PUSHER_CLUSTER
  PUSHER_AUTH_ENDPOINT: PUSHER_AUTH_ENDPOINT

  ###
    Available languages
  ###
  languages: [
    Em.Object.create
      code: "en"
      name: gettext("English")
    Em.Object.create
      code: "en-gb"
      name: gettext("British English")
    Em.Object.create
      code: "fr"
      name: gettext("French")
  ]

  ###
    Supported countries for registration
  ###
  supportedCountries: [
    Em.Object.create
      countryCode: "BE"
      countryName: gettext("Belgium")
    Em.Object.create
      countryCode: "CH"
      countryName: gettext("Switzerland")
    Em.Object.create
      countryCode: "FR"
      countryName: gettext("France")
    Em.Object.create
      countryCode: "GB"
      countryName: gettext("Great Britain")
    Em.Object.create
      countryCode: "LU"
      countryName: gettext("Luxembourg")
    Em.Object.create
      countryCode: "US"
      countryName: gettext("United States")
  ]

  ###
    Possible list of user statutes
  ###
  userStatutes: [
    Em.Object.create
      value: "ACTIVE"
      label: gettext("Active")
    Em.Object.create
      value: "DISABLED"
      label: gettext("Disabled")
    Em.Object.create
      value: "DELETED"
      label: gettext("Deleted")
  ]

  ###
    Available font families for pdf report
  ###
  reportFontFamilies: [
    Em.Object.create
      value: "bariol"
      name: gettext("Bariol (Vosae's font)")
    Em.Object.create
      value: "helvetica"
      name: "Helvetica"
    Em.Object.create
      value: "times"
      name: "Times New Roman"
    Em.Object.create
      value: "courier"
      name: "Courier New"
  ]

  ###
    Available font sizes for pdf report
  ###
  reportFontSizes: [
    Em.Object.create
      value: 8
      name: '8pt'
    Em.Object.create
      value: 9
      name: '9pt'
    Em.Object.create
      value: 10
      name: '10pt'
    Em.Object.create
      value: 11
      name: '11pt'
    Em.Object.create
      value: 12
      name: '12pt'
    Em.Object.create
      value: 13
      name: '13pt'
    Em.Object.create
      value: 14
      name: '14pt'
  ]

  ###
    Available paper sizes for pdf report
  ###
  reportPaperSizes: [
    Em.Object.create
      value: 'a4'
      name: gettext 'A4 (8.27" x 11.69")'
    Em.Object.create
      value: 'letter'
      name: gettext 'Letter (8.5" x 11")'
    Em.Object.create
      value: 'legal'
      name: gettext 'Legal (8.5" x 14")'
  ]

  ###
    Available email types
  ###
  emailTypeChoice: [
    Ember.Object.create
      name: gettext "Work"
      value: "WORK"
    Ember.Object.create
      name: gettext "Home"
      value: "HOME"
  ]

  ###
    Available address types
  ###
  addressTypeChoice: [
    Ember.Object.create
      name: gettext "Work"
      value: "WORK"
    Ember.Object.create
      name: gettext "Home"
      value: "HOME"
    Ember.Object.create
      name: gettext "Delivery"
      value: "DELIVERY"
    Ember.Object.create
      name: gettext "Billing"
      value: "BILLING"
    Ember.Object.create
      name: gettext "Other"
      value: "OTHER"
  ]

  ###
    Available phone types
  ###
  phoneCombinedTypes: [
    Ember.Object.create
      name: gettext "Work"
      value: "WORK"
      type: "WORK"
      subtype: null
    Ember.Object.create
      name: gettext "Home"
      value: "HOME"
      type: "HOME"
      subtype: null
    Ember.Object.create
      name: gettext "Work cell"
      value: "WORK-CELL"
      type: "WORK"
      subtype: "CELL"
    Ember.Object.create
      name: gettext "Home cell"
      value: "HOME-CELL"
      type: "HOME"
      subtype: "CELL"
    Ember.Object.create
      name: gettext "Work fax"
      value: "WORK-FAX"
      type: "WORK"
      subtype: "FAX"
    Ember.Object.create
      name: gettext "Home fax"
      value: "HOME-FAX"
      type: "HOME"
      subtype: "FAX"
  ]

  ###
    Available contact civility
  ###
  contactCivilityChoice: [
    Ember.Object.create
      name: gettext "Mr"
      value: "Mr."
    Ember.Object.create
      name: gettext "Mrs"
      value: "Mrs."
    Ember.Object.create
      name: gettext "Miss"
      value: "Miss"
  ]

  ###
    Available attendee response statutes
  ###
  attendeeResponseStatutes: [
    Em.Object.create
      displayName: pgettext 'attendee response status', 'Unknown'
      fullDisplayName: pgettext 'attendee response status', 'Participation unknown'
      value: 'NEEDS-ACTION'
    Em.Object.create
      displayName: pgettext 'attendee response status', 'Declined'
      fullDisplayName: pgettext 'attendee response status', 'Participation declined'
      value: 'DECLINED'
    Em.Object.create
      displayName: pgettext 'attendee response status', 'Maybe'
      fullDisplayName: pgettext 'attendee response status', 'Participation uncertain'
      value: 'TENTATIVE'
    Em.Object.create
      displayName: pgettext 'attendee response status', 'Confirmed'
      fullDisplayName: pgettext 'attendee response status', 'Participation confirmed'
      value: 'ACCEPTED'
  ]

  ###
    Available reminder for calendar's events
  ###
  reminderEntries: [
    Em.Object.create
      displayName: pgettext 'reminder entry', 'Notification'
      value: 'POPUP'
    Em.Object.create
      displayName: pgettext 'reminder entry', 'E-mail'
      value: 'EMAIL'
  ]

  ###
    Available acl rules for calendars
  ###
  calendarAclRuleRoles: [
    Em.Object.create
      displayName: pgettext 'calendar acl rule role', 'has no access'
      value: 'NONE'
    Em.Object.create
      displayName: pgettext 'calendar acl rule role', 'can see events'
      value: 'READER'
    Em.Object.create
      displayName: pgettext 'calendar acl rule role', 'can edit events'
      value: 'WRITER'
    Em.Object.create
      displayName: pgettext 'calendar acl rule role', 'is owner'
      value: 'OWNER'
  ]

  ###
    Available colors for calendar
  ###
  calendarListColors: [
    Em.Object.create
      displayName: pgettext 'calendar list color', 'Green'
      value: '#dcf85f'
    Em.Object.create
      displayName: pgettext 'calendar list color', 'Fluorescent green'
      value: '#c7f784'
    Em.Object.create
      displayName: pgettext 'calendar list color', 'Blue'
      value: '#a3d7ea'
    Em.Object.create
      displayName: pgettext 'calendar list color', 'Orange'
      value: '#ffa761'
    Em.Object.create
      displayName: pgettext 'calendar list color', 'Red'
      value: '#eb5f3a'
    Em.Object.create
      displayName: pgettext 'calendar list color', 'Dark green'
      value: '#74a31e'
    Em.Object.create
      displayName: pgettext 'calendar list color', 'Dark blue'
      value: '#44b2ae'
    Em.Object.create
      displayName: pgettext 'calendar list color', 'Purple'
      value: '#7f54c0'
    Em.Object.create
      displayName: pgettext 'calendar list color', 'Dark purple'
      value: '#390a59'
  ]

  ###
    Available payments types
  ###
  paymentTypes: [
    Ember.Object.create
      label: pgettext("payment method", "Cash")
      value: "CASH"
    Ember.Object.create
      label: pgettext("payment method", "Check")
      value: "CHECK"
    Ember.Object.create
      label: pgettext("payment method", "Credit card")
      value: "CREDIT_CARD"
    Ember.Object.create
      label: pgettext("payment method", "Bank transfer")
      value: "TRANSFER"
    Ember.Object.create
      label: pgettext("payment method", "Other")
      value: "OTHER"
  ]

  ###
    Available payments conditions 
  ###
  paymentConditions: [
    Ember.Object.create
      label: pgettext("payment conditions", "Cash")
      numDays: 0
      endOfMonth: false
      afterDays: 0
      value: "CASH"
    Ember.Object.create
      label: pgettext("payment conditions", "30 days")
      numDays: 30
      endOfMonth: false
      afterDays: 0
      value: "30D"
    Ember.Object.create
      label: pgettext("payment conditions", "30 days end of month")
      numDays: 30
      endOfMonth: true
      afterDays: 0
      value: "30D-EOM"
    Ember.Object.create
      label: pgettext("payment conditions", "30 days end of month, the 10th")
      numDays: 30
      endOfMonth: true
      afterDays: 10
      value: "30D-EOM-10"
    Ember.Object.create
      label: pgettext("payment conditions", "45 days")
      numDays: 45
      endOfMonth: false
      afterDays: 0
      value: "45D"
    Ember.Object.create
      label: pgettext("payment conditions", "45 days end of month")
      numDays: 45
      endOfMonth: true
      afterDays: 0
      value: "45D-EOM"
    Ember.Object.create
      label: pgettext("payment conditions", "45 days end of month, the 10th")
      numDays: 45
      endOfMonth: true
      afterDays: 10
      value: "45D-EOM-10"
    Ember.Object.create
      label: pgettext("payment conditions", "60 days")
      numDays: 60
      endOfMonth: false
      afterDays: 0
      value: "60D"
    Ember.Object.create
      label: pgettext("payment conditions", "60 days end of month")
      numDays: 60
      endOfMonth: true
      afterDays: 0
      value: "60D-EOM"
    Ember.Object.create
      label: pgettext("payment conditions", "60 days end of month, the 10th")
      numDays: 60
      endOfMonth: true
      afterDays: 10
      value: "60D-EOM-10"
    Ember.Object.create
      label: pgettext("payment conditions", "Custom")
      numDays: 0
      endOfMonth: false
      afterDays: 0
      value: "CUSTOM"
  ]

  ###
    Available types for item (Product / Service)
  ###
  itemsTypeChoices: [
    Ember.Object.create
      label: gettext("Product")
      value: "PRODUCT"
    Ember.Object.create
      label: gettext("Service")
      value: "SERVICE"
  ]

  ###
    Available states for a quotation
  ###
  quotationStatesChoices: [
    Ember.Object.create
      label: pgettext("quotation state", "Draft")
      value: "DRAFT"
    Ember.Object.create
      label: pgettext("quotation state", "Expired")
      value: "EXPIRED"
    Ember.Object.create
      label: pgettext("quotation state", "Awaiting approval")
      markAsLabel: pgettext("quotation", "Mark as awaiting approval")
      value: "AWAITING_APPROVAL"
    Ember.Object.create
      label: pgettext("quotation state", "Refused")
      markAsLabel: pgettext("quotation", "Mark as refused")
      value: "REFUSED"
    Ember.Object.create
      label: pgettext("quotation state", "Approved")
      markAsLabel: pgettext("quotation", "Mark as approved")
      value: "APPROVED"
    Ember.Object.create
      label: pgettext("quotation state", "Invoiced")
      value: "INVOICED"
  ]

  ###
    Available states for an invoice
  ###
  invoiceStatesChoices: [
    Ember.Object.create
      label: pgettext("invoice state", "Draft")
      value: "DRAFT"
    Ember.Object.create
      label: pgettext("invoice state", "Registered")
      markAsLabel: pgettext("invoice", "Mark as registered")
      value: "REGISTERED"
    Ember.Object.create
      label: pgettext("invoice state", "Part paid")
      value: "PART_PAID"
    Ember.Object.create
      label: pgettext("invoice state", "Overdue")
      value: "OVERDUE"
    Ember.Object.create
      label: pgettext("invoice state", "Paid")
      value: "PAID"
    Ember.Object.create
      label: pgettext("invoice state", "Cancelled")
      value: "CANCELLED"
  ]

  ###
    Description for each currencies
  ###
  currenciesDescription: [
    Ember.Object.create
      symbol: "AUD"
      description: gettext("Australian dollar")
    Ember.Object.create
      symbol: "BRL"
      description: gettext("Brazilian real")
    Ember.Object.create
      symbol: "CAD"
      description: gettext("Canadian dollar")
    Ember.Object.create
      symbol: "CHF"
      description: gettext("Swiss franc")
    Ember.Object.create
      symbol: "CNY"
      description: gettext("Chinese yuan")
    Ember.Object.create
      symbol: "DKK"
      description: gettext("Danish krone")
    Ember.Object.create
      symbol: "EGP"
      description: gettext("Egyptian pound")
    Ember.Object.create
      symbol: "EUR"
      description: gettext("Euro")
    Ember.Object.create
      symbol: "GBP"
      description: gettext("Pound sterling")
    Ember.Object.create
      symbol: "HKD"
      description: gettext("Hong Kong dollar")
    Ember.Object.create
      symbol: "INR"
      description: gettext("Indian rupee")
    Ember.Object.create
      symbol: "JPY"
      description: gettext("Japanese yen")
    Ember.Object.create
      symbol: "MAD"
      description: gettext("Moroccan dirham")
    Ember.Object.create
      symbol: "MXN"
      description: gettext("Mexican peso")
    Ember.Object.create
      symbol: "NOK"
      description: gettext("Norwegian krone")
    Ember.Object.create
      symbol: "NZD"
      description: gettext("New Zealand dollar")
    Ember.Object.create
      symbol: "RUB"
      description: gettext("Russian rouble")
    Ember.Object.create
      symbol: "SEK"
      description: gettext("Swedish krona")
    Ember.Object.create
      symbol: "TRY"
      description: gettext("Turkish lira")
    Ember.Object.create
      symbol: "USD"
      description: gettext("United States dollar")
  ]

  ###
    Sign for each currencies
  ###
  currenciesSign: [
    Ember.Object.create
      symbol: 'AUD'
      sign: '$'
    Ember.Object.create
      symbol: 'BRL'
      sign: 'R$'
    Ember.Object.create
      symbol: 'CAD'
      sign: '$'
    Ember.Object.create
      symbol: 'CHF'
      sign: 'Fr'
    Ember.Object.create
      symbol: 'CNY'
      sign: '¥'
    Ember.Object.create
      symbol: 'DKK'
      sign: 'kr'
    Ember.Object.create
      symbol: 'EGP'
      sign: '£'
    Ember.Object.create
      symbol: 'EUR'
      sign: '€'
    Ember.Object.create
      symbol: 'GBP'
      sign: '£'
    Ember.Object.create
      symbol: 'HKD'
      sign: '$'
    Ember.Object.create
      symbol: 'INR'
      sign: '₹'
    Ember.Object.create
      symbol: 'JPY'
      sign: '¥'
    Ember.Object.create
      symbol: 'MAD'
      sign: 'د.م.'
    Ember.Object.create
      symbol: 'MXN'
      sign: '$'
    Ember.Object.create
      symbol: 'NOK'
      sign: 'kr'
    Ember.Object.create
      symbol: 'NZD'
      sign: '$'
    Ember.Object.create
      symbol: 'RUB'
      sign: 'р.'
    Ember.Object.create
      symbol: 'SEK'
      sign: 'kr'
    Ember.Object.create
      symbol: 'TRY'
      sign: '£'
    Ember.Object.create
      symbol: 'USD'
      sign: '$'
  ]

  ###
    List of available schemes for invoice and quotation references
  ###
  invoicingSchemes: [
    Ember.Object.create
      label: gettext("Date, Number")
      value: "DN"
    Ember.Object.create
      label: gettext("Number")
      value: "N"
  ]

  ###
    List of available date formats for invoice and quotation references
  ###
  invoicingDateFormats: [
    Ember.Object.create
      value: "Ymd"
      label: "YYYYMMDD"
    Ember.Object.create
      value: "dmY"
      label: "DDMMYYYY"
    Ember.Object.create
      value: "ymd"
      label: "YYMMDD"
    Ember.Object.create
      value: "dmy"
      label: "DDMMYY"
    Ember.Object.create
      value: "Ym"
      label: "YYYYMM"
    Ember.Object.create
      value: "mY"
      label: "MMYYYY"
    Ember.Object.create
      value: "ym"
      label: "YYMM"
    Ember.Object.create
      value: "my"
      label: "MMYY"
    Ember.Object.create
      value: "Y"
      label: "YYYY"
    Ember.Object.create
      value: "y"
      label: "YY"
  ] 

  ###
    List of available separators between date and number in references
  ###
  invoicingSeparators: [
    Ember.Object.create
      value: ""
      label: gettext("No separator")
    Ember.Object.create
      value: "-"
      label: gettext("- (dash)")
    Ember.Object.create
      value: "_"
      label: gettext("_ (underscore)")
    Ember.Object.create
      value: "."
      label: gettext(". (dot)")
    Ember.Object.create
      value: ":"
      label: gettext(": (colon)")
    Ember.Object.create
      value: "::"
      label: gettext(":: (bi-colon)")
    Ember.Object.create
      value: "/"
      label: gettext("/ (slash)")
    Ember.Object.create
      value: "#"
      label: gettext("# (sharp)")
  ]

  ###
    TODO
  ###
  invoicingDateStrftimeFormats: [
    Ember.Object.create
      value: "Ymd"
      label: "%Y%m%d"
    Ember.Object.create
      value: "dmY"
      label: "%d%m%Y"
    Ember.Object.create
      value: "ymd"
      label: "%y%m%d"
    Ember.Object.create
      value: "dmy"
      label: "%d%m%y"
    Ember.Object.create
      value: "Ym"
      label: "%Y%m"
    Ember.Object.create
      value: "mY"
      label: "%m%Y"
    Ember.Object.create
      value: "ym"
      label: "%y%m"
    Ember.Object.create
      value: "my"
      label: "%m%y"
    Ember.Object.create
      value: "Y"
      label: "%Y"
    Ember.Object.create
      value: "y"
      label: "%y"
  ]


###
  Return the correct due date based on a date and the passed 
  payment conditions.

  @method getDueDate
  @param {Date} baseDate The date to update according to conditions
  @param {Object} conditions The object that contains conditions infos
  @returns {Date}
###
Vosae.Config.paymentConditions.getDueDate = (baseDate, conditions) ->
  dueDate = moment(baseDate).add('days', conditions.numDays)
  if conditions.endOfMonth
    dueDate.endOf('month')
  dueDate.add('days', conditions.afterDays).toDate()
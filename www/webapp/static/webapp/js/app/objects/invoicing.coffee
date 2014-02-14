# Payments related objects
Vosae.paymentTypes = [
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

Vosae.paymentConditions = [
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

Vosae.paymentConditions.getDueDate = (baseDate, conditions)->
  dueDate = moment(baseDate).add('days', conditions.numDays)
  if conditions.endOfMonth
    dueDate.endOf('month')
  dueDate.add('days', conditions.afterDays).toDate()

# Items related objects
Vosae.itemsTypeChoices = [
  Ember.Object.create
    label: gettext("Product")
    value: "PRODUCT"
  Ember.Object.create
    label: gettext("Service")
    value: "SERVICE"
]

Vosae.itemsTypeFilterChoices = [
  Ember.Object.create
    label: gettext("Products & Services")
    value: "all"
  Ember.Object.create
    label: gettext("Products")
    value: "products"
  Ember.Object.create
    label: gettext("Services")
    value: "services"
]

Vosae.itemsSortPropertiesChoices = [
  Ember.Object.create
    label: gettext("Reference")
    value: "ref"
  Ember.Object.create
    label: gettext("Description")
    value: "description"
  Ember.Object.create
    label: gettext("Unit price")
    value: "unitPrice"
  Ember.Object.create
    label: gettext("Default tax")
    value: "tax.displayTax"
]

# Quotations related objects
Vosae.quotationsSortPropertiesChoices = [
  Ember.Object.create
    label: gettext("Validity date")
    value: "currentRevision.quotationValidity"
  Ember.Object.create
    label: gettext("Reference")
    value: "ref"
  Ember.Object.create
    label: gettext("Total tax included")
    value: "total"
]

Vosae.quotationStatesChoices = [
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

# Invoices related objects
Vosae.invoicesSortPropertiesChoices = [
  Ember.Object.create
    label: gettext("Due date")
    value: "currentRevision.dueDate"
  Ember.Object.create
    label: gettext("Reference")
    value: "ref"
  Ember.Object.create
    label: gettext("Total tax included")
    value: "total"
]

Vosae.invoiceStatesChoices = [
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

# Currencies related objects
Vosae.currenciesDescription = [
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

Vosae.currenciesSign = [
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

# Other
Vosae.sortAscendingChoices = [
  Ember.Object.create
    label: gettext("Ascending")
    value: true
  Ember.Object.create
    label: gettext("Descending")
    value: false
]
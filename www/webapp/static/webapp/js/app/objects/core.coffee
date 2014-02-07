Vosae.Session = Ember.Object.extend
  forbidenTenantsNames: ["tenants"]
  preWindowLocation: null
  tenant: null
  tenantSettings: null
  preselectedTenant: null
  nextUrl: null

  init: ->
    @_super()

    # Parse URL and extract tenant before app start
    unless window.testMode
      location = Vosae.get 'preWindowLocation'
      Vosae.DEBUG = @
      if location      
        pathname = location.pathname
        tenant = pathname.split('/')[1]
         
        unless @forbidenTenantsNames.contains tenant
          @preselectedTenant = tenant
          @nextUrl = pathname

Vosae.userStatutes = Em.makeArray([
  Em.Object.create
    value: "ACTIVE"
    label: gettext("Active")
  Em.Object.create
    value: "DISABLED"
    label: gettext("Disabled")
  Em.Object.create
    value: "DELETED"
    label: gettext("Deleted")
])

Vosae.languages = Em.makeArray([
  Em.Object.create
    code: "en"
    name: gettext("English")
  Em.Object.create
    code: "en-gb"
    name: gettext("British English")
  Em.Object.create
    code: "fr"
    name: gettext("French")
])

Vosae.reportFontFamilies = [
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

Vosae.reportFontSizes = [
  Em.Object.create
    value: 8
    name: '8px'
  Em.Object.create
    value: 9
    name: '9px'
  Em.Object.create
    value: 10
    name: '10px'
  Em.Object.create
    value: 11
    name: '11px'
  Em.Object.create
    value: 12
    name: '12px'
  Em.Object.create
    value: 13
    name: '13px'
  Em.Object.create
    value: 14
    name: '14px'
]

Vosae.reportPaperSizes = [
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

Vosae.supportedCountries = Em.makeArray([
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
])

Vosae.exportDocumentsTypes = Em.makeArray([
  Em.Object.create
    value: "CONTACT"
    name: gettext("Contact")
  Em.Object.create
    value: "ORGANIZATION"
    name: gettext("Organization")
  Em.Object.create
    value: "QUOTATION"
    name: gettext("Quotation")
  Em.Object.create
    value: "INVOICE"
    name: gettext("Invoice")
  Em.Object.create
    value: "CREDIT_NOTE"
    name: gettext("Credit note")
])

Vosae.permissions = Em.makeArray([
  Em.Object.create
    displayName: gettext('Core permissions')
    perms: Em.makeArray([
      Em.Object.create
        perm: 'core_access'
        authorization: false
        name: gettext('Access to the application')
      Em.Object.create
        perm: 'change_appconf'
        authorization: false
        name: gettext('Can configure application')
      Em.Object.create
        perm: 'see_vosaeuser'
        authorization: false
        name: gettext('Can see users')
      Em.Object.create
        perm: 'add_vosaeuser'
        authorization: false
        name: gettext('Can add users')
      Em.Object.create
        perm: 'change_vosaeuser'
        authorization: false
        name: gettext('Can edit users')
      Em.Object.create
        perm: 'delete_vosaeuser'
        authorization: false
        name: gettext('Can delete users')
      Em.Object.create
        perm: 'see_vosaegroup'
        authorization: false
        name: gettext('Can see groups')
      Em.Object.create
        perm: 'add_vosaegroup'
        authorization: false
        name: gettext('Can add groups')
      Em.Object.create
        perm: 'change_vosaegroup'
        authorization: false
        name: gettext('Can edit groups')
      Em.Object.create
        perm: 'delete_vosaegroup'
        authorization: false
        name: gettext('Can delete groups')
      Em.Object.create
        perm: 'see_vosaefile'
        authorization: false
        name: gettext('Can download files')
      Em.Object.create
        perm: 'add_vosaefile'
        authorization: false
        name: gettext('Can upload files')
      Em.Object.create
        perm: 'delete_vosaefile'
        authorization: false
        name: gettext('Can delete files')
    ])
  
  Em.Object.create
    displayName: gettext('Contacts permissions')
    perms: Em.makeArray([
      Em.Object.create
        perm: 'contacts_access'
        authorization: false
        name: gettext('Access to the contacts module')
      Em.Object.create
        perm: 'see_contact'
        authorization: false
        name: gettext('Can see contacts')
      Em.Object.create
        perm: 'add_contact'
        authorization: false
        name: gettext('Can add contacts')
      Em.Object.create
        perm: 'change_contact'
        authorization: false
        name: gettext('Can edit contacts')
      Em.Object.create
        perm: 'delete_contact'
        authorization: false
        name: gettext('Can delete contacts')
    ])

  Em.Object.create
    displayName: gettext('Invoicing permissions')
    perms: Em.makeArray([
      Em.Object.create
        perm: 'invoicing_access'
        authorization: false
        name: gettext('Access to the invoicing module')
      Em.Object.create
        perm: 'change_invoicingsettings'
        authorization: false
        name: gettext('Can edit invoicing settings')
      Em.Object.create
        perm: 'see_invoicebase'
        authorization: false
        name: gettext('Can see invoices')
      Em.Object.create
        perm: 'add_invoicebase'
        authorization: false
        name: gettext('Can add invoices')
      Em.Object.create
        perm: 'change_invoicebase'
        authorization: false
        name: gettext('Can edit invoices')
      Em.Object.create
        perm: 'delete_invoicebase'
        authorization: false
        name: gettext('Can delete/cancel invoices')
      Em.Object.create
        perm: 'transmit_invoicebase'
        authorization: false
        name: gettext('Can transmit invoices')
      Em.Object.create
        perm: 'post_invoicebase'
        authorization: false
        name: gettext('Can post invoices')
      Em.Object.create
        perm: 'see_item'
        authorization: false
        name: gettext('Can see items')
      Em.Object.create
        perm: 'add_item'
        authorization: false
        name: gettext('Can add items')
      Em.Object.create
        perm: 'change_item'
        authorization: false
        name: gettext('Can edit items')
      Em.Object.create
        perm: 'delete_item'
        authorization: false
        name: gettext('Can delete items')
    ])

  Em.Object.create
    displayName: gettext('Organizer permissions')
    perms: Em.makeArray([
      Em.Object.create
        perm: 'organizer_access'
        authorization: false
        name: gettext('Access to the calendar module')
    ])
])


Vosae.dashboardAppFilter = Em.Object.create
  showAppContact: true
  showAppInvoicing: true
  showAppOrganizer: true
  showAppContactAsChanged: false
  showAppInvoicingAsChanged: false
  showAppOrganizerAsChanged: false
  
  updateAppFilter: ->
    vosae_base.adjustContentHeight()

  resetFilterObservers: ->
    @set "showAppContactAsChanged", false
    @set "showAppInvoicingAsChanged", false
    @set "showAppOrganizerAsChanged", false

  observesFilterContact: (->
    @set "showAppContactAsChanged", true
    @updateAppFilter()
  ).observes("showAppContact")

  observesFilterOrganizer: (->
    @set "showAppOrganizerAsChanged", true
    @updateAppFilter()
  ).observes("showAppOrganizer")

  observesFilterInvoicing: (->
    @set "showAppInvoicingAsChanged", true
    @updateAppFilter()
  ).observes("showAppInvoicing")
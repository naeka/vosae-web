###
  List of permissions available for Vosae, grouped by module :
    1) core
    2) contacts
    3) organizer
    4) invoicing
  
  @class Permissions
  @namespace Vosae
  @module Vosae
###

Vosae.Permissions = [

  # Core permissions
  Em.Object.create
    displayName: gettext('Core permissions')
    perms: [
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
    ]
  ,

  # Contacts permissions
  Em.Object.create
    displayName: gettext('Contacts permissions')
    perms: [
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
    ]
  ,

  # Organizer permissions
  Em.Object.create
    displayName: gettext('Organizer permissions')
    perms: [
      Em.Object.create
        perm: 'organizer_access'
        authorization: false
        name: gettext('Access to the calendar module')
    ]
  ,

  # Invoicing permissions
  Em.Object.create
    displayName: gettext('Invoicing permissions')
    perms: [
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
    ]
]
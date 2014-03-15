###
  Set the `Vosae.ApplicationController` as dependencie
  for all controllers.
###

Ember.Controller.reopen
  needs: ['application']

Ember.ObjectController.reopen
  needs: ['application']

Ember.ArrayController.reopen
  needs: ['application']


###
  A custom array controller for Vosae.

  @class ArrayController
  @extends Ember.ArrayController
  @namespace Vosae
  @module Vosae
###

Vosae.ArrayController = Ember.ArrayController.extend
  meta: null

  ###
    Make the metadata for the related model available in the templates
  ###
  setMeta: (->
    type = @getRelatedType()
    @set "meta", @store.metadataFor(type) if type
  ).on "init"

  ###
    Returns the model related to the controller
  ###
  getRelatedType: ->
    type = switch
      when @ instanceof Vosae.DashboardIndexController then Vosae.Timeline
      when @ instanceof Vosae.NotificationsController then Vosae.Notification
      when @ instanceof Vosae.ContactsShowController then Vosae.Contact
      when @ instanceof Vosae.OrganizationsShowController then Vosae.Organization
      when @ instanceof Vosae.InvoicesShowController then Vosae.Invoice
      when @ instanceof Vosae.QuotationsShowController then Vosae.Quotation
      when @ instanceof Vosae.ItemsShowController then Vosae.Item
      when @ instanceof Vosae.PurchaseOrdersShowController then Vosae.PurchaseOrder
      when @ instanceof Vosae.SettingsApiKeysController then Vosae.ApiKey
      else undefined
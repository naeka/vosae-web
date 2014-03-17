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
      when @ instanceof Vosae.DashboardIndexController then "timeline"
      when @ instanceof Vosae.NotificationsController then "notification"
      when @ instanceof Vosae.ContactsShowController then "contact"
      when @ instanceof Vosae.OrganizationsShowController then "organization"
      when @ instanceof Vosae.InvoicesShowController then "invoice"
      when @ instanceof Vosae.QuotationsShowController then "quotation"
      when @ instanceof Vosae.ItemsShowController then "item"
      when @ instanceof Vosae.PurchaseOrdersShowController then "purchaseOrder"
      when @ instanceof Vosae.SettingsApiKeysController then "apiKey"
      else undefined

  actions:
    ###
      Fetch more model entries
    ###
    getNextPagination: ->
      type = @getRelatedType()
      meta = @get "meta"
      # If there's metadata and more records to load
      if type and meta.get "canFetchMore"
        meta.set 'loading', true
        # Fetch old timeline entries
        @store.find(type).then =>
          meta.set 'loading', false
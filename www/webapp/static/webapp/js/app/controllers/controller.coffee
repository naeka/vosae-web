###
  Set the `Vosae.ApplicationController` as dependencie
  for all controllers.
###

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

  getModel :->
    switch @constructor.toString()
      when Vosae.NotificationsController.toString() then Vosae.Notification
      when Vosae.ContactsShowController.toString() then Vosae.Contact
      when Vosae.OrganizationsShowController.toString() then Vosae.Organization
      when Vosae.InvoicesShowController.toString() then Vosae.Invoice
      when Vosae.QuotationsShowController.toString() then Vosae.Quotation
      when Vosae.ItemsShowController.toString() then Vosae.Item
      when Vosae.PurchaseOrdersShowController.toString() then Vosae.PurchaseOrder
      when Vosae.SettingsApiKeysController.toString() then Vosae.ApiKey

  init: ->
    @_super()

    switch @constructor.toString()
      when Vosae.NotificationsController.toString() then @set 'meta', Vosae.metaForNotification
      when Vosae.ContactsShowController.toString() then @set 'meta', Vosae.metaForContact
      when Vosae.OrganizationsShowController.toString() then @set 'meta', Vosae.metaForOrganization
      when Vosae.InvoicesShowController.toString() then @set 'meta', Vosae.metaForInvoice
      when Vosae.QuotationsShowController.toString() then @set 'meta', Vosae.metaForQuotation
      when Vosae.ItemsShowController.toString() then @set 'meta', Vosae.metaForItem
      when Vosae.PurchaseOrdersShowController.toString() then @set 'meta', Vosae.metaForPurchaseOrder
      when Vosae.SettingsApiKeysController.toString() then @set 'meta', Vosae.metaForApiKey

    # Check if model hasn't be fetched yet
    if @get('meta') and !@get('meta.modelHasBeenFetched')
      @send("getNextPagination")

  actions:
    # Pagination retrieve next model objects
    getNextPagination: ->
      pagination = null

      if @get('meta') and !@get('meta.loading')
        if @get('meta.next') or !@get('meta.modelHasBeenFetched')
          offset = if @get('meta.offset')? then @get('meta.offset') + @get('meta.limit') else 0
          pagination =
            data: @getModel().find(offset: offset)
            offset: @get('meta.offset')
            limit: @get('meta.limit')
            lastLength: @getModel().all().get('length')
          @set 'meta.loading', true

      return pagination
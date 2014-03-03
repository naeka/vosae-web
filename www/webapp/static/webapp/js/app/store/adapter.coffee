###
  Main adapter for Vosae

  @class Adapter
  @extends DS.RESTAdapter
  @namespace Vosae
  @module Vosae
###

Vosae.Adapter = DS.RESTAdapter.extend
  serializer: Vosae.Serializer.create()
  namespace: Vosae.Config.API_NAMESPACE
  url: Vosae.Config.APP_ENDPOINT
  bulkCommit: false
  since: "next"

  ###
    Make the adapter available for the serializer
  ###
  injectAdapterInSerializer: (->
    serializer = @get "serializer"
    serializer.set "adapter", @
  ).on "init"

  rejectionHandler: (reason) ->
    if window.Raven?
      Raven.captureException reason
    Ember.Logger.error "[#{reason.statusText}] #{reason.responseText}", reason
    throw reason

  ###
    Returns Meta controller for the specific model. This should be
    removed when we will use ember data 1.X
  ###
  getMetaForModel: (model) ->
    switch model
      when Vosae.Contact
        Vosae.metaForContact
      when Vosae.Organization
        Vosae.metaForOrganization
      when Vosae.Quotation
        Vosae.metaForQuotation
      when Vosae.Invoice
        Vosae.metaForInvoice
      when Vosae.Timeline
        Vosae.metaForTimeline
      when Vosae.Notification
        Vosae.metaForNotification
      when Vosae.Item
        Vosae.metaForItem
      when Vosae.Tenant
        Vosae.metaForTenant
      when Vosae.Currency
        Vosae.metaForCurrency
      when Vosae.PurchaseOrder
        Vosae.metaForPurchaseOrder
      else
        `undefined`

  ###
    This method save meta data returned by the api for a specific model
    and query. It should be removed when will use ember data 1.X.
  ###
  storeMetaData: (meta, model, query) ->
    unless meta is `undefined`
      metaController = @getMetaForModel(model)
      unless metaController is `undefined`
        if query
          if not metaController.get('queries')
            metaController.set('queries', Em.Object.create())
          dict = Em.Object.create()
          $.each meta, (key, value) ->
            dict.set(key, value)
          metaController.get('queries').set(query, dict)
        else
          $.each meta, (key, value) ->
            metaController.set key, value

        metaController.set 'loading', false

  createRecord: (store, type, record) ->
    json = {}
    root = @rootForType(type)
    adapter = this
    data = @serialize(record)
    
    @ajax(@buildURL(root), "POST",
      data: data
    ).then((pre_json) ->
      json[root] = pre_json
      adapter.didCreateRecord store, type, record, json
    , (xhr) ->
      adapter.didError store, type, record, xhr
      throw xhr
    ).then null, adapter.rejectionHandler

  updateRecord: (store, type, record) ->
    json = {}
    id = Ember.get record, "id"
    root = @rootForType(type)
    adapter = this
    data = @serialize(record)

    @ajax(@buildURL(root, id), "PUT",
      data: data
    ).then((pre_json) ->
      json[root] = pre_json
      adapter.didUpdateRecord store, type, record, json
    , (xhr) ->
      adapter.didError store, type, record, xhr
      throw xhr
    ).then null, adapter.rejectionHandler

  find: (store, type, id) ->
    json = {}
    root = @rootForType(type)
    adapter = this
    @ajax(@buildURL(root, id), "GET").then((pre_json) ->
        # Transforms key 'objects' from JSON by type
        # Example for model Contact json['objects'] -> json['contact']
      json[root] = pre_json
      adapter.didFindRecord store, type, json, id
    ).then null, adapter.rejectionHandler

  findMany: (store, type, ids, owner) ->
    json = {}
    root = @rootForType(type)
    adapter = this
    ids = @serializeIds(ids)
    plural = @pluralize(root)

    if ids instanceof Array
      ids = "set/" + ids.join(";") + "/"

    @ajax(@buildURL(root) + ids, "GET").then((pre_json) ->
      json[plural] = pre_json['objects']
      adapter.didFindMany store, type, json
    ).then null, adapter.rejectionHandler

  findQuery: (store, type, query, recordArray) ->
    json = {}
    root = @rootForType(type)
    plural = @pluralize(root)
    adapter = this
    
    @ajax(@buildURL(root), "GET",
      data: query
    ).then((pre_json) ->
      # Transforms key 'objects' from JSON by pluralize of type
      # Example : for model Contact json['objects'] -> json['contact']
      json['meta'] = pre_json['meta']
      json[plural] = pre_json['objects']
      if json.meta
        adapter.storeMetaData(json.meta, type)
      adapter.didFindQuery store, type, json, recordArray
    ).then null, adapter.rejectionHandler

  findAll: (store, type, since) ->
    json = {}
    root = @rootForType(type)
    plural = @pluralize(root)
    adapter = this

    @ajax(@buildURL(root), "GET",
      data: @sinceQuery(since)
    ).then((pre_json) ->
      # Transforms key 'objects' from JSON by pluralize of type
      # Example : for model Contact json['objects'] -> json['contact']
      json['meta'] = pre_json['meta']
      json[plural] = pre_json['objects']
      if json.meta
        adapter.storeMetaData(json.meta, type)
      adapter.didFindAll store, type, json
    ).then null, adapter.rejectionHandler

  buildURL: (record, suffix) ->
    url = @_super(record, suffix)    
    # Add the trailing slash to avoid setting requirement in Django.settings
    if url.charAt(url.length - 1) isnt "/"
      url += "/"  
    # Add the server domain if any
    url = @removeTrailingSlash(@serverDomain) + url  unless not @serverDomain
    url

  sinceQuery: (since) ->
    query = {}
    if since
      offsetParam = since.match(/offset=(\d+)/)
      offsetParam = (if (!!offsetParam and !!offsetParam[1]) then offsetParam[1] else null)
      query.offset = offsetParam
    (if offsetParam then query else null)

  removeTrailingSlash: (url) ->
    return url.slice(0, -1) if url.charAt(url.length - 1) is "/"

  didError: (store, type, record, xhr) ->
    switch xhr.status
      when 400
        serializer = @get 'serializer'
        json = JSON.parse(xhr.responseText)
        errors = serializer.extractValidationErrors type, json
        store.recordWasInvalid record, errors
      when 500
        Vosae.ErrorPopupComponent.open
          message: gettext('An error occurred, please try again or contact the support')
        switch record.get 'currentState.stateName'
          when 'root.loaded.created.inFlight'
            record.set 'currentState', DS.RootState.loaded.created.uncommitted
          when 'root.loaded.updated.inFlight'
            record.set 'currentState', DS.RootState.loaded.updated.uncommitted
  
  pluralize: (name) ->
    name


###
  Configuration for timeline entries polymorph
###
Vosae.Adapter.configure 'Vosae.ContactSavedTE',
  alias: 'contact_saved_te'
Vosae.Adapter.configure 'Vosae.OrganizationSavedTE',
  alias: 'organization_saved_te'
Vosae.Adapter.configure 'Vosae.QuotationSavedTE',
  alias: 'quotation_saved_te'
Vosae.Adapter.configure 'Vosae.InvoiceSavedTE',
  alias: 'invoice_saved_te'
Vosae.Adapter.configure 'Vosae.DownPaymentInvoiceSavedTE',
  alias: 'down_payment_invoice_saved_te'
Vosae.Adapter.configure 'Vosae.CreditNoteSavedTE',
  alias: 'credit_note_saved_te'
Vosae.Adapter.configure 'Vosae.QuotationChangedStateTE',
  alias: 'quotation_changed_state_te'
Vosae.Adapter.configure 'Vosae.InvoiceChangedStateTE',
  alias: 'invoice_changed_state_te'
Vosae.Adapter.configure 'Vosae.DownPaymentInvoiceChangedStateTE',
  alias: 'down_payment_invoice_changed_state_te'
Vosae.Adapter.configure 'Vosae.CreditNoteChangedStateTE',
  alias: 'credit_note_changed_state_te'
Vosae.Adapter.configure 'Vosae.QuotationMakeInvoiceTE',
  alias: 'quotation_make_invoice_te'
Vosae.Adapter.configure 'Vosae.QuotationMakeDownPaymentInvoiceTE',
  alias: 'quotation_make_down_payment_invoice_te'
Vosae.Adapter.configure 'Vosae.InvoiceCancelledTE',
  alias: 'invoice_cancelled_te'
Vosae.Adapter.configure 'Vosae.DownPaymentInvoiceCancelledTE',
  alias: 'down_payment_invoice_cancelled_te'

###
  Configuration for notifications polymorph
###
Vosae.Adapter.configure 'Vosae.ContactSavedNE',
  alias: 'contact_saved_ne'
Vosae.Adapter.configure 'Vosae.OrganizationSavedNE',
  alias: 'organization_saved_ne'
Vosae.Adapter.configure 'Vosae.QuotationSavedNE',
  alias: 'quotation_saved_ne'
Vosae.Adapter.configure 'Vosae.InvoiceSavedNE',
  alias: 'invoice_saved_ne'
Vosae.Adapter.configure 'Vosae.DownPaymentInvoiceSavedNE',
  alias: 'down_payment_invoice_saved_ne'
Vosae.Adapter.configure 'Vosae.CreditNoteSavedNE',
  alias: 'credit_note_saved_ne'
Vosae.Adapter.configure 'Vosae.EventReminderNE',
  alias: 'event_reminder_ne'

###
  Configuration for registration info polymorph
###
Vosae.Adapter.configure 'Vosae.BeRegistrationInfo',
  alias: 'be_registration_info'
Vosae.Adapter.configure 'Vosae.ChRegistrationInfo',
  alias: 'ch_registration_info'
Vosae.Adapter.configure 'Vosae.FrRegistrationInfo',
  alias: 'fr_registration_info'
Vosae.Adapter.configure 'Vosae.GbRegistrationInfo',
  alias: 'gb_registration_info'
Vosae.Adapter.configure 'Vosae.LuRegistrationInfo',
  alias: 'lu_registration_info'
Vosae.Adapter.configure 'Vosae.UsRegistrationInfo',
  alias: 'us_registration_info'
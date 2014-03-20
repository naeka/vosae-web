###
  Custom array controller for a collection of `Vosae.PurchaseOrder` records.

  @class PurchaseOrdersShowController
  @extends Ember.ArrayController
  @namespace Vosae
  @module Vosae
###

Vosae.PurchaseOrdersShowController = Ember.ArrayController.extend
  sortProperties: ['currentRevision.dueDate']
  sortAscending: false
  queryLimit: 5

  metaPending: null
  metaFailed: null
  metaSucceeded: null

  checkQueryLimit: (->
    Ember.Logger.error(@toString() + " needs the `queryLimit` property to be defined.") if Em.isNone @queryLimit
  ).on "init"

  ###
    Fetch each query once on controller initialization
  ###
  fetchQueriesOnce: (->
    @set "content", @store.all("purchaseOrder")

    # Create meta for queries
    @createMetadataForQueries()

    # Fetch queries
    @send "getNextPaginationPending"
    @send "getNextPaginationSucceeded"
  ).on "init"

  ###
    Create a metadata object for each queries
  ###
  createMetadataForQueries: ->
    # Create a meta object for each queries
    @set "metaPending", Em.Object.createWithMixins Vosae.MetaMixin, 
      name: 'pending'
    @set "metaSucceeded", Em.Object.createWithMixins Vosae.MetaMixin,
      name: 'succeeded'

    # Push meta to their meta parent queries array
    queries = @get("store").metadataFor("purchaseOrder").get("queries")
    queries.push @get("metaPending")
    queries.push @get("metaSucceeded")

  ###
    Queries for grouping purchaseOrders by states
  ###
  queryPending: Ember.Object.create
    name: 'pending'
    query: 'state__in=DRAFT&state__in=AWAITING_APPROVAL&state__in=REFUSED'

  querySucceeded: Ember.Object.create
    name: 'succeeded'
    query: 'state__in=APPROVED&state__in=INVOICED'

  ###
    Returns purchaseOrders grouped by states
  ###
  purchaseOrdersPending: (->
    @get("content").filter (purchaseOrder) ->
      ['DRAFT', 'AWAITING_APPROVAL'].contains purchaseOrder.get('state')
  ).property('content.length', 'content.@each.state')

  purchaseOrdersSucceeded: (->
    @get("content").filter (purchaseOrder) ->
      ['APPROVED', 'INVOICED'].contains purchaseOrder.get('state')
  ).property('content.length', 'content.@each.state')

  ###
    Main method that will check meta for the specific query and fetch data

    @query {Object} The query object with the name of the query and the query her self
  ###
  getNextPaginationForQuery: (query, meta)  ->
    # Nothing to do if there's no query object
    return if !query or !query.hasOwnProperty("name")

    if !meta.get('hasBeenFetched')
      queryString = query.get('query') + '&offset=' + 0 + '&limit=' + @get("queryLimit")
    else
      queryString = query.get('query') + '&offset=' + meta.get('since') + '&limit=' + @get("queryLimit")

    meta.setProperties
      "lastQuery": queryString
      "loading": true

    @store.findQuery('purchaseOrder', queryString).then () ->
      meta.set "loading", false

  ###
    Actions handler for pagination
  ###
  actions:
    getNextPaginationPending: ->
      query = @get("queryPending")
      meta = @get("metaPending")
      @getNextPaginationForQuery query, meta

    getNextPaginationSucceeded: ->
      query = @get("querySucceeded")
      meta = @get("metaSucceeded")
      @getNextPaginationForQuery query, meta

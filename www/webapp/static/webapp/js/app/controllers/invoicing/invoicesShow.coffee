###
  Custom array controller for a collection of `Vosae.Invoice` records.

  @class InvoicesShowController
  @extends Vosae.ArrayController
  @namespace Vosae
  @module Vosae
###

Vosae.InvoicesShowController = Em.ArrayController.extend
  sortProperties: ['currentRevision.dueDate']
  sortAscending: false
  queryLimit: 5

  metaPending: null
  metaOverdue: null
  metaPaid: null

  checkQueryLimit: (->
    Ember.Logger.error(@toString() + " needs the `queryLimit` property to be defined.") if Em.isNone @queryLimit
  ).on "init"

  ###
    Fetch each query once on controller initialization
  ###
  fetchQueriesOnce: (->
    @set "content", @store.all("invoice")

    # Create meta for queries
    @createMetadataForQueries()

    # Fetch queries
    @send "getNextPaginationPending"
    @send "getNextPaginationOverdue"
    @send "getNextPaginationPaid"
  ).on "init"

  ###
    Create a metadata object for each queries
  ###
  createMetadataForQueries: ->
    # Create a meta object for each queries
    @set "metaPending", Em.Object.createWithMixins Vosae.MetaMixin, 
      name: 'pending'
    @set "metaOverdue", Em.Object.createWithMixins Vosae.MetaMixin, 
      name: 'overdue'
    @set "metaPaid", Em.Object.createWithMixins Vosae.MetaMixin,
      name: 'paid'

    # Push meta to their meta parent queries array
    queries = @get("store").metadataFor("invoice").get("queries")
    queries.push @get("metaPending")
    queries.push @get("metaOverdue")
    queries.push @get("metaPaid")

  ###
    Queries for grouping invoices by states
  ###
  queryPending: Ember.Object.create
    name: 'pending'
    query: 'state__in=DRAFT&?state__in=REGISTERED&?state__in=PART_PAID'

  queryOverdue: Ember.Object.create
    name: 'overdue'
    query: 'state__in=OVERDUE'

  queryPaid: Ember.Object.create
    name: 'paid'
    query: 'state__in=PAID&?state__in=CANCELLED'

  ###
    Returns invoices grouped by states
  ###
  invoicesPending: (->
    @get("content").filter (invoice) ->
      ['DRAFT', 'REGISTERED', 'PART_PAID'].contains invoice.get('state')
  ).property('content.length', 'content.@each.state')

  invoicesOverdue: (->
    @get("content").filter (invoice) ->
      ['OVERDUE'].contains invoice.get('state')
  ).property('content.length', 'content.@each.state')

  invoicesPaid: (->
    @get("content").filter (invoice) ->
      ['PAID', 'CANCELLED'].contains invoice.get('state')
  ).property('content.length', 'content.@each.state')

  ###
    Main method that will check meta for the specific query and fetch data

    @query {Object} The query object with the name of the query and the query her self
  ###
  getNextPaginationForQuery: (query, meta)  ->
    # Nothing to do if there's no query object
    return if !query or !query.hasOwnProperty("name")

    if !meta.get('hasBeenFetched')
      queryString = query.get('query') + '&?offset=' + 0 + '&?limit=' + @get("queryLimit")
    else
      queryString = query.get('query') + '&?offset=' + meta.get('since') + '&?limit=' + @get("queryLimit")

    meta.setProperties
      "lastQuery": queryString
      "loading": true

    @store.findQuery('invoice', queryString).then () ->
      meta.set "loading", false

  ###
    Actions handler for pagination
  ###
  actions:
    getNextPaginationPending: ->
      query = @get("queryPending")
      meta = @get("metaPending")
      @getNextPaginationForQuery query, meta

    getNextPaginationOverdue: ->
      query = @get("queryOverdue")
      meta = @get("metaOverdue")
      @getNextPaginationForQuery query, meta

    getNextPaginationPaid: ->
      query = @get("queryPaid")
      meta = @get("metaPaid")
      @getNextPaginationForQuery query, meta

###
  Custom array controller for a collection of `Vosae.Quotation` records.

  @class QuotationsShowController
  @extends Vosae.ArrayController
  @namespace Vosae
  @module Vosae
###

Vosae.QuotationsShowController = Ember.ArrayController.extend
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
    @set "content", @store.all("quotation")

    # Create meta for queries
    @createMetadataForQueries()

    # Fetch queries
    @send "getNextPaginationPending"
    @send "getNextPaginationFailed"
    @send "getNextPaginationSucceeded"
  ).on "init"

  ###
    Create a metadata object for each queries
  ###
  createMetadataForQueries: ->
    # Create a meta object for each queries
    @set "metaPending", Em.Object.createWithMixins Vosae.MetaMixin, 
      name: 'pending'
    @set "metaFailed", Em.Object.createWithMixins Vosae.MetaMixin, 
      name: 'failed'
    @set "metaSucceeded", Em.Object.createWithMixins Vosae.MetaMixin,
      name: 'succeeded'

    # Push meta to their meta parent queries array
    queries = @get("store").metadataFor("quotation").get("queries")
    queries.push @get("metaPending")
    queries.push @get("metaFailed")
    queries.push @get("metaSucceeded")

  ###
    Queries for grouping quotations by states
  ###
  queryPending: Ember.Object.create
    name: 'pending'
    query: 'state__in=DRAFT&?state__in=AWAITING_APPROVAL'

  queryFailed: Ember.Object.create
    name: 'failed'
    query: 'state__in=EXPIRED&?state__in=REFUSED'

  querySucceeded: Ember.Object.create
    name: 'succeeded'
    query: 'state__in=APPROVED&?state__in=INVOICED'

  ###
    Returns quotations grouped by states
  ###
  quotationsPending: (->
    @get("content").filter (quotation) ->
      ['DRAFT', 'AWAITING_APPROVAL'].contains quotation.get('state')
  ).property('content.length', 'content.@each.state')

  quotationsFailed: (->
    @get("content").filter (quotation) ->
      ['EXPIRED', 'REFUSED'].contains quotation.get('state')
  ).property('content.length', 'content.@each.state')

  quotationsSucceeded: (->
    @get("content").filter (quotation) ->
      ['APPROVED', 'INVOICED'].contains quotation.get('state')
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

    @store.findQuery('quotation', queryString).then () ->
      meta.set "loading", false

  ###
    Actions handler for pagination
  ###
  actions:
    getNextPaginationPending: ->
      query = @get("queryPending")
      meta = @get("metaPending")
      @getNextPaginationForQuery query, meta

    getNextPaginationFailed: ->
      query = @get("queryFailed")
      meta = @get("metaFailed")
      @getNextPaginationForQuery query, meta

    getNextPaginationSucceeded: ->
      query = @get("querySucceeded")
      meta = @get("metaSucceeded")
      @getNextPaginationForQuery query, meta

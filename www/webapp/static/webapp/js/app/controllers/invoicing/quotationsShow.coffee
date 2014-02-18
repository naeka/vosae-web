###
  Custom array controller for a collection of `Vosae.Quotation` records.

  @class QuotationsShowController
  @extends Vosae.InvoicesBaseController
  @namespace Vosae
  @module Vosae
###

Vosae.QuotationsShowController = Vosae.InvoicesBaseController.extend
  sortProperties: ['currentRevision.dueDate']
  sortAscending: false

  actions:
    getNextQuotationsDraft: ->
      lastQueryDraft = @get('meta.queries').get(@get('paginationDraft.metaQueryName'))
      if lastQueryDraft 
        newQueryDraft =
          name: @get('paginationDraft.metaQueryName')
          string: @get('paginationDraft.query') + '&offset=' + (lastQueryDraft.get('limit') + lastQueryDraft.get('offset'))
        @getModel().find(newQueryDraft)
    
    getNextQuotationsExpired: ->
      lastQueryExpired = @get('meta.queries').get(@get('paginationExpired.metaQueryName'))
      if lastQueryExpired
        newQueryExpired =
          name: @get('paginationExpired.metaQueryName')
          string: @get('paginationExpired.query') + '&offset=' + (lastQueryExpired.get('limit') + lastQueryExpired.get('offset'))
        @getModel().find(newQueryExpired)

    getNextQuotationsApproved: ->
      lastQueryApproved = @get('meta.queries').get(@get('paginationApproved.metaQueryName'))
      if lastQueryApproved
        newQueryApproved =
          name: @get('paginationApproved.metaQueryName')
          string: @get('paginationApproved.query') + '&offset=' + (lastQueryApproved.get('limit') + lastQueryApproved.get('offset'))
        @getModel().find(newQueryApproved)

  totalOfSelection: (->
    total = 0
    @get('content').forEach (x, idx, i) ->
      total = total + x.get('total')
    return accounting.formatMoney(total, "EUR")
  ).property('content.length')

  ##
  # Queries for grouping quotations by states
  #
  paginationDraft: Ember.Object.create
    metaQueryName: 'stateIsDraftOrAwaitingApproval'
    query: 'state__in=DRAFT&state__in=AWAITING_APPROVAL'
  
  paginationExpired: Ember.Object.create
    metaQueryName: 'stateIsExpiredOrRefused'
    query: 'state__in=EXPIRED&state__in=REFUSED'
  
  paginationApproved: Ember.Object.create
    metaQueryName: 'stateIsApprovedOrInvoiced'
    query: 'state__in=APPROVED&state__in=INVOICED'

  ##
  # Returns quotations grouped by states
  #
  quotationsDraftAwaitingApproval: (->
    ret = []
    Vosae.Quotation.all().forEach (quotation) ->
      if ['DRAFT', 'AWAITING_APPROVAL'].contains(quotation.get('state'))
        ret.addObject(quotation)
    ret
  ).property('content.length', 'content.@each.state')

  quotationsExpiredRefused: (->
    ret = []
    Vosae.Quotation.all().forEach (quotation) ->
      if ['EXPIRED', 'REFUSED'].contains(quotation.get('state'))
        ret.addObject(quotation)
    ret
  ).property('content.length', 'content.@each.state')

  quotationsApprovedInvoiced: (->
    ret = []
    Vosae.Quotation.all().forEach (quotation) ->
      if ['APPROVED', 'INVOICED'].contains(quotation.get('state'))
        ret.addObject(quotation)
    ret
  ).property('content.length', 'content.@each.state')

  ##
  # Those properties indicates if more quotations can be loaded
  # 
  paginationDraftHasNext: (->
    if @get('meta.queries.stateIsDraftOrAwaitingApproval.next')
      return true
    false
  ).property('meta.queries.stateIsDraftOrAwaitingApproval')

  paginationExpiredHasNext: (->
    if @get('meta.queries.stateIsExpiredOrRefused.next')
      return true
    false
  ).property('meta.queries.stateIsExpiredOrRefused')

  paginationApprovedHasNext: (->
    if @get('meta.queries.stateIsApprovedOrInvoiced.next')
      return true
    false
  ).property('meta.queries.stateIsApprovedOrInvoiced')

  getNextPagination: ->
    if @get('meta') && @getModel()

      if @get('meta.queries')
        queryDraftExist = @get('meta.queries')[@get('paginationDraft.metaQueryName')]
        queryExpiredExist = @get('meta.queries')[@get('paginationDraft.metaQueryName')]
        queryApprovedExist = @get('meta.queries')[@get('paginationDraft.metaQueryName')]
    
      else
        queryDraftExist = null
        queryExpiredExist = null
        queryApprovedExist = null

      # First time call 
      unless queryDraftExist && queryExpiredExist && queryApprovedExist
        
        # DRAFT & AWAITING_APPROVAL
        queryDraft =
          name: @get('paginationDraft.metaQueryName')
          string: @get('paginationDraft.query') + '&offset=0'
        @getModel().find(queryDraft)

        # EXPIRED & REFUSED
        queryExpired =
          name: @get('paginationExpired.metaQueryName')
          string: @get('paginationExpired.query') + '&offset=0'
        @getModel().find(queryExpired)

        # APPROVED & INVOICED
        queryApproved =
          name: @get('paginationApproved.metaQueryName')
          string: @get('paginationApproved.query') + '&offset=0'
        @getModel().find(queryApproved)
###
  Custom array controller for a collection of `Vosae.PurchaseOrder` records.

  @class PurchaseOrdersShowController
  @extends Vosae.InvoicesBaseController
  @namespace Vosae
  @module Vosae
###

Vosae.PurchaseOrdersShowController = Vosae.ArrayController.extend
  sortProperties: ['currentRevision.dueDate']
  sortAscending: false

  actions:
    getNextPurchaseOrdersPending: ->
      lastQueryPending = @get('meta.queries').get(@get('paginationPending.metaQueryName'))
      if lastQueryPending 
        newQueryPending =
          name: @get('paginationPending.metaQueryName')
          string: @get('paginationPending.query') + '&offset=' + (lastQueryPending.get('limit') + lastQueryPending.get('offset'))
        @getModel().find(newQueryDraft)
    
    getNextPurchaseOrdersApproved: ->
      lastQueryApproved = @get('meta.queries').get(@get('paginationApproved.metaQueryName'))
      if lastQueryApproved
        newQueryApproved =
          name: @get('paginationApproved.metaQueryName')
          string: @get('paginationApproved.query') + '&offset=' + (lastQueryApproved.get('limit') + lastQueryApproved.get('offset'))
        @getModel().find(newQueryApproved)

  ##
  # Queries for grouping purchase orders by states
  #
  paginationPending: Ember.Object.create
    metaQueryName: 'stateIsDraftOrPendingApprovalorRefused'
    query: 'state__in=DRAFT&state__in=AWAITING_APPROVAL&state__in=REFUSED'
  
  paginationApproved: Ember.Object.create
    metaQueryName: 'stateIsApprovedOrInvoiced'
    query: 'state__in=APPROVED&state__in=INVOICED'

  ##
  # Returns purchase orders grouped by states
  #
  purchaseOrdersPending: (->
    ret = []
    Vosae.PurchaseOrder.all().forEach (purchaseOrder) ->
      if ['DRAFT', 'AWAITING_APPROVAL'].contains(purchaseOrder.get('state'))
        ret.addObject(purchaseOrder)
    ret
  ).property('content.length', 'content.@each.state')

  purchaseOrdersApproved: (->
    ret = []
    Vosae.PurchaseOrder.all().forEach (purchaseOrder) ->
      if ['APPROVED', 'INVOICED'].contains(purchaseOrder.get('state'))
        ret.addObject(purchaseOrder)
    ret
  ).property('content.length', 'content.@each.state')

  ##
  # Those properties indicates if more quotations can be loaded
  # 
  paginationPendingHasNext: (->
    if @get('meta.queries.stateIsDraftOrPendingApprovalorRefused.next')
      return true
    false
  ).property('meta.queries.stateIsDraftOrPendingApprovalorRefused')

  paginationApprovedHasNext: (->
    if @get('meta.queries.stateIsApprovedOrInvoiced.next')
      return true
    false
  ).property('meta.queries.stateIsApprovedOrInvoiced')

  getNextPagination: ->
    if @get('meta') && @getModel()

      if @get('meta.queries')
        queryPendingExist = @get('meta.queries')[@get('paginationPending.metaQueryName')]
        queryApprovedExist = @get('meta.queries')[@get('paginationApproved.metaQueryName')]
  
      else
        queryDraftExist = null
        queryApprovedExist = null

      # First time call 
      unless queryPendingExist && queryApprovedExist
        
        # DRAFT & AWAITING_APPROVAL & REFUSED
        queryDraft =
          name: @get('paginationPending.metaQueryName')
          string: @get('paginationPending.query') + '&offset=0'
        @getModel().find(queryDraft)

        # APPROVED & INVOICED
        queryApproved =
          name: @get('paginationApproved.metaQueryName')
          string: @get('paginationApproved.query') + '&offset=0'
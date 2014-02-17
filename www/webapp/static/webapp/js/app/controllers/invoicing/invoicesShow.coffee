###
  Custom array controller for a collection of `Vosae.Invoice` records.

  @class InvoicesShowController
  @extends Vosae.InvoicesBaseController
  @namespace Vosae
  @module Vosae
###

Vosae.InvoicesShowController = Vosae.InvoicesBaseController.extend
  sortProperties: ['currentRevision.dueDate']
  sortAscending: false

  actions:
    getNextInvoicesPending: ->
      lastQueryPending = @get('meta.queries').get(@get('paginationPending.metaQueryName'))
      if lastQueryPending 
        newQueryPending =
          name: @get('paginationPending.metaQueryName')
          string: @get('paginationPending.query') + '&offset=' + (lastQueryPending.get('limit') + lastQueryPending.get('offset'))
        @getModel().find(newQueryPending)
    
    getNextInvoicesOverdue: ->
      lastQueryOverdue = @get('meta.queries').get(@get('paginationOverdue.metaQueryName'))
      if lastQueryOverdue
        newQueryOverdue =
          name: @get('paginationOverdue.metaQueryName')
          string: @get('paginationOverdue.query') + '&offset=' + (lastQueryOverdue.get('limit') + lastQueryOverdue.get('offset'))
        @getModel().find(newQueryOverdue)

    getNextInvoicesPaid: ->
      lastQueryPaid = @get('meta.queries').get(@get('paginationPaid.metaQueryName'))
      if lastQueryPaid
        newQueryPaid =
          name: @get('paginationPaid.metaQueryName')
          string: @get('paginationPaid.query') + '&offset=' + (lastQueryPaid.get('limit') + lastQueryPaid.get('offset'))
        @getModel().find(newQueryPaid)
  
  totalOfSelection: (->
    total = 0
    @get('content').forEach (x, idx, i) ->
      total = total + x.get('total')
    return accounting.formatMoney(total, "EUR")
  ).property('content.length')

  ##
  # Queries for grouping invoices by states
  #
  paginationPending: Ember.Object.create
    metaQueryName: 'stateIsPending'
    query: 'state__in=DRAFT&state__in=REGISTERED&state__in=PART_PAID'
  
  paginationOverdue: Ember.Object.create
    metaQueryName: 'stateIsOverdue'
    query: 'state__in=OVERDUE'
  
  paginationPaid: Ember.Object.create
    metaQueryName: 'stateIsPaid'
    query: 'state__in=PAID&state__in=CANCELLED'

  ##
  # Returns invoices grouped by states
  #
  invoicesPending: (->
    ret = []
    Vosae.Invoice.all().forEach (invoice) ->
      if ['DRAFT', 'REGISTERED', 'PART_PAID'].contains(invoice.get('state'))
        ret.addObject(invoice)
    ret
  ).property('content.length', 'content.@each.state')

  invoicesOverdue: (->
    ret = []
    Vosae.Invoice.all().forEach (invoice) ->
      if ['OVERDUE'].contains(invoice.get('state'))
        ret.addObject(invoice)
    ret
  ).property('content.length', 'content.@each.state')

  invoicesPaid: (->
    ret = []
    Vosae.Invoice.all().forEach (invoice) ->
      if ['PAID', 'CANCELLED'].contains(invoice.get('state'))
        ret.addObject(invoice)
    ret
  ).property('content.length', 'content.@each.state')

  ##
  # Those properties indicates if more invoices can be loaded
  # 
  paginationPendingHasNext: (->
    if @get('meta.queries.stateIsPending.next')
      return true
    false
  ).property('meta.queries.stateIsPending')

  paginationOverdueHasNext: (->
    if @get('meta.queries.stateIsOverdue.next')
      return true
    false
  ).property('meta.queries.stateIsOverdue')

  paginationPaidHasNext: (->
    if @get('meta.queries.stateIsPaid.next')
      return true
    false
  ).property('meta.queries.stateIsPaid')

  getNextPagination: ->
    if @get('meta') && @getModel()

      if @get('meta.queries')
        queryPendingExist = @get('meta.queries')[@get('paginationPending.metaQueryName')]
        queryOverdueExist = @get('meta.queries')[@get('paginationOverdue.metaQueryName')]
        queryPaidExist = @get('meta.queries')[@get('paginationPaid.metaQueryName')]
    
      else
        queryPendingExist = null
        queryOverdueExist = null
        queryPaidExist = null

      # First time call 
      unless queryPendingExist && queryOverdueExist && queryPaidExist
        
        # DRAFT & REGISTERED & PART_PAID
        queryPending =
          name: @get('paginationPending.metaQueryName')
          string: @get('paginationPending.query') + '&offset=0'
        @getModel().find(queryPending)

        # OVERDUE
        queryOverdue =
          name: @get('paginationOverdue.metaQueryName')
          string: @get('paginationOverdue.query') + '&offset=0'
        @getModel().find(queryOverdue)

        # PAID & CANCELLED
        queryPaid =
          name: @get('paginationPaid.metaQueryName')
          string: @get('paginationPaid.query') + '&offset=0'
        @getModel().find(queryPaid)
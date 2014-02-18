###
  Custom array controller for the invoicing dashboard. Manages invoicing
  statistics, pending quotations and draft invoices.

  @class InvoicingDashboardController
  @extends Ember.ArrayController
  @namespace Vosae
  @module Vosae
###

Vosae.InvoicingDashboardController = Em.ArrayController.extend
  needs: ['invoicing', 'invoicingFyFlowStatistics']
  itemsPerTable: 5
  defaultCurrencyBinding: Em.Binding.oneWay('session.tenantSettings.invoicing.defaultCurrency')
  invoicingFyFlowStatisticsBinding: Em.Binding.oneWay('controllers.invoicingFyFlowStatistics')

  init: ->
    @_super()
    @get('needs').addObjects(['quotationsShow', 'invoicesShow'])
    
  # invoicesTotalCount: (->
  #   if(@get('invoicesController.meta.totalCount') <= @get('itemsPerTable'))
  #     return 0
  #   return (@get('invoicesController.meta.totalCount') - @get('itemsPerTable'))
  # ).property('invoicesController.meta.totalCount', 'itemsPerTable')

  # quotationsTotalCount: (->
  #   if(@get('quotationsController.meta.totalCount') <= @get('itemsPerTable'))
  #     return 0
  #   return (@get('quotationsController.meta.totalCount') - @get('itemsPerTable'))
  # ).property('quotationsController.meta.totalCount', 'itemsPerTable')

  invoicesOverdue: (->
    # Returns a maxium of 5 invoices in state OVERDUE
    invoices = @get('controllers.invoicesShow.invoicesOverdue')
    if invoices.get('length')
      return invoices.slice(0, 5)
    return []
  ).property('controllers.invoicesShow.invoicesOverdue.length')

  quotationsDraftAwaitingApproval: (->
    # Returns a maxium of 5 quotations in state DRAFT or AWAITING_APPROVAL
    quotations = @get('controllers.quotationsShow.quotationsDraftAwaitingApproval')
    if quotations.get('length')
      return quotations.slice(0, 5)
    return []
  ).property('controllers.quotationsShow.quotationsDraftAwaitingApproval.length')

  shouldDisplayAllQuotationsButton: (->
    # Return true if there is more than 5 quotation in state DRAFT or AWAITING_APPROVAL
    if @get('controllers.quotationsShow.quotationsDraftAwaitingApproval.length') > @get('itemsPerTable')
      return true
    false
  ).property('controllers.quotationsShow.quotationsDraftAwaitingApproval.length')

  shouldDisplayAllInvoicesButton: (->
    # Return true if there is more than 5 invoice in state OVERDUE
    if @get('controllers.invoicesShow.invoicesOverdue.length') > @get('itemsPerTable')
      return true
    false
  ).property('controllers.invoicesShow.invoicesOverdue.length')
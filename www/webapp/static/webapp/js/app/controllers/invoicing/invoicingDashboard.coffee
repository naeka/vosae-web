###
  Custom array controller for the invoicing dashboard. Manages invoicing
  statistics, pending quotations and draft invoices.

  @class InvoicingDashboardController
  @extends Ember.ArrayController
  @namespace Vosae
  @module Vosae
###

Vosae.InvoicingDashboardController = Em.ArrayController.extend
  needs: ['invoicing', 'invoicingFyFlowStatistics', 'quotationsShow', 'invoicesShow', 'purchaseOrdersShow']
  itemsPerTable: 5
  defaultCurrencyBinding: Em.Binding.oneWay('session.tenantSettings.invoicing.defaultCurrency')
  invoicingFyFlowStatisticsBinding: Em.Binding.oneWay('controllers.invoicingFyFlowStatistics')

  ###
    Returns a maxium of 5 invoices in state OVERDUE
  ###
  invoicesOverdue: (->
    @get('controllers.invoicesShow.invoicesOverdue').slice(0, @itemsPerTable)
  ).property('controllers.invoicesShow.invoicesOverdue.length')

  ###
    Returns a maxium of 5 invoices in state DRAFT, REGISTERED or PART_PAID
  ###
  invoicesPending: (->
    @get('controllers.invoicesShow.invoicesPending').slice(0, @itemsPerTable)
  ).property('controllers.invoicesShow.invoicesPending.length')

  ###
    Returns a maxium of 5 quotations in state DRAFT or AWAITING_APPROVAL
  ###
  quotationsPending: (->
    @get('controllers.quotationsShow.quotationsPending').slice(0, @itemsPerTable)
  ).property('controllers.quotationsShow.quotationsPending.length')

  ###
    Returns a maxium of 5 purchase orders in state DRAFT or AWAITING_APPROVAL
  ###
  purchaseOrdersPending: (->
    @get('controllers.purchaseOrdersShow.purchaseOrdersPending').slice(0, @itemsPerTable)
  ).property('controllers.purchaseOrdersShow.purchaseOrdersPending.length')

  ###
    Returns true if there is more than 5 invoice in state OVERDUE
  ###
  moreInvoicesOverdue: (->
    @get('controllers.invoicesShow.metaOverdue.totalCount') > @itemsPerTable
  ).property('controllers.invoicesShow.metaOverdue.totalCount')
  
  ###
    Returns true if there is more than 5 invoice in state DRAFT, REGISTERED or PART_PAID
  ###
  moreInvoicesPending: (->
    @get('controllers.invoicesShow.metaPending.totalCount') > @itemsPerTable
  ).property('controllers.invoicesShow.metaPending.totalCount')
  
  ###
    Returns true if there is more than 5 quotation in state DRAFT or AWAITING_APPROVAL
  ###
  moreQuotationsPending: (->
    @get('controllers.quotationsShow.metaPending.totalCount') > @itemsPerTable
  ).property('controllers.quotationsShow.metaPending.totalCount')

  ###
    Returns true if there is more than 5 purchase orders in state DRAFT or AWAITING_APPROVAL
  ###
  morePurchaseOrdersPending: (->
    @get('controllers.purchaseOrdersShow.metaPending.totalCount') > @itemsPerTable
  ).property('controllers.purchaseOrdersShow.metaPending.totalCount')
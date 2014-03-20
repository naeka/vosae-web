###
  Custom array controller for the invoicing dashboard. Manages invoicing
  statistics, pending quotations and draft invoices.

  @class InvoicingDashboardController
  @extends Ember.ArrayController
  @namespace Vosae
  @module Vosae
###

Vosae.InvoicingDashboardController = Em.ArrayController.extend
  needs: ['invoicing', 'invoicingFyFlowStatistics', 'quotationsShow', 'invoicesShow']
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
    Returns a maxium of 5 quotations in state DRAFT or AWAITING_APPROVAL
  ###
  quotationsPending: (->
    @get('controllers.quotationsShow.quotationsPending').slice(0, @itemsPerTable)
  ).property('controllers.quotationsShow.quotationsPending.length')

  ###
    Returns true if there is more than 5 quotation in state DRAFT or AWAITING_APPROVAL
  ###
  moreQuotationsPending: (->
    @get('controllers.quotationsShow.metaPending.totalCount') > @itemsPerTable
  ).property('controllers.quotationsShow.metaPending.totalCount')

  ###
    Returns true if there is more than 5 invoice in state OVERDUE
  ###
  moreInvoicesOverdue: (->
    @get('controllers.invoicesShow.metaOverdue.totalCount') > @itemsPerTable
  ).property('controllers.invoicesShow.metaOverdue.totalCount')
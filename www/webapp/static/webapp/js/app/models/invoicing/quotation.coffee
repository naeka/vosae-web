###
  A data model that represents a quotation

  @class Quotation
  @extends Vosae.InvoiceBase
  @namespace Vosae
  @module Vosae
###

Vosae.Quotation = Vosae.InvoiceBase.extend
  state: DS.attr('string')

  isMakingInvoice: false

  displayState: (->
    # Returns the current state readable and translated.
    Vosae.Config.quotationStatesChoices.findProperty('value', @get('state')).get('label')
  ).property('state')

  availableStates: (->
    # List the available states for the `Quotation`, depending of its current state.
    if @get('state') is "DRAFT"
      Vosae.Config.quotationStatesChoices.filter (state) ->
        if ["AWAITING_APPROVAL", "APPROVED", "REFUSED"].contains state.get('value')
          state
    else if @get('state') is "AWAITING_APPROVAL"
      Vosae.Config.quotationStatesChoices.filter (state) ->
        if ["APPROVED", "REFUSED"].contains state.get('value')
          state
    else if @get('state') is "EXPIRED"
      Vosae.Config.quotationStatesChoices.filter (state) ->
        if ["AWAITING_APPROVAL", "APPROVED", "REFUSED"].contains state.get('value')
          state
    else if @get('state') is "REFUSED"
      Vosae.Config.quotationStatesChoices.filter (state) ->
        if ["AWAITING_APPROVAL", "APPROVED"].contains state.get('value')
          state
    else
      return []
  ).property('state')
  
  isInvoiceable: (->
    # `Quotation` is invoiceable unless it has been invoiced.
    if @get('group.relatedInvoice')
      return false
    return true
  ).property('group.relatedInvoice')

  isModifiable: (->
    # `Quotation` is modifiable unless it has been invoiced.
    if @get('group.relatedInvoice')
      return false
    return true
  ).property('group.relatedInvoice')

  isDeletable: (->
    # `Quotation` is is deletable if not linked to any
    # `Invoice` or `DownPaymentInvoice`.
    if @get('group.relatedInvoice') or !Em.isEmpty(@get('group.downPaymentInvoices')) or !@get('id')
      return false
    return true
  ).property('group.relatedInvoice', 'group.downPaymentInvoices.length', 'id')

  isIssuable: (->
    # Determine if the `Quotation` could be sent.
    if ["DRAFT"].contains(@get('state')) or !@get('state')
      return false
    return true
  ).property('state')

  isInvoiced: (->
    # Returns true if the `Quotation` is invoiced.
    if @get('state') is "INVOICED"
      return true
    return false
  ).property('state')

  getErrors: ->
    # Return an array of string that contains form validation errors 
    errors = []
    errors = errors.concat @get("currentRevision").getErrors("Quotation")
    return errors
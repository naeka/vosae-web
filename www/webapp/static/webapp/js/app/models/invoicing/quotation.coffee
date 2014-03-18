###
  A data model that represents a quotation

  @class Quotation
  @extends Vosae.InvoiceBase
  @use Vosae.InvoiceMakableMixin
  @namespace Vosae
  @module Vosae
###

Vosae.Quotation = Vosae.InvoiceBase.extend Vosae.InvoiceMakableMixin,
  state: DS.attr('string')
  currentRevision: DS.belongsTo('Vosae.QuotationRevision')
  # revisions: DS.hasMany('Vosae.QuotationRevision')

  isQuotation: true

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

  isIssuable: (->
    # Determine if the `Quotation` could be sent.
    if ["DRAFT"].contains(@get('state')) or !@get('state')
      return false
    return true
  ).property('state')

  getErrors: ->
    # Return an array of string that contains form validation errors 
    errors = []
    errors = errors.concat @get("currentRevision").getErrors("Quotation")
    return errors


Vosae.Adapter.map "Vosae.Quotation",
  # revisions:
  #   embedded: "always"
  ref:
    key: "reference"
  notes:
    embedded: "always"
  currentRevision:
    embedded: "always"
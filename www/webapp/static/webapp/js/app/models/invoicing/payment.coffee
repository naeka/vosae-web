###
  A data model that represents a payment

  @class Payment
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.Payment = Vosae.Model.extend
  issuer: DS.belongsTo('user')
  issuedAt: DS.attr('datetime')
  amount: DS.attr('number')
  currency: DS.belongsTo('currency')
  type: DS.attr('string')
  date: DS.attr('date')
  note: DS.attr('string')
  relatedTo: DS.belongsTo('invoice')

  displayDate: (->
    # Return the date formated
    if @get("date")?
      return moment(@get("date")).format "LL"
    return pgettext("date", "undefined")
  ).property("date")

  displayAmount: (->
    # Display amount formating
    if @get("amount")
      return accounting.formatNumber(@get("amount"), precision: 2)
    return ''
  ).property("amount")

  displayType: (->
    # Display the payment type
    if @get("type")
      return Vosae.Config.paymentTypes.findProperty('value', @get('type')).get('label')
    return pgettext("payment type", "undefined")
  ).property("type")

  displayNote: (->
    # Return the note or -
    if @get("note")
      return @get("note")
    return "-"
  ).property("note")

  amountMax: (->
    # Return the amount maximum converted with current currency.
    paymentCur = @get('currency')
    invoiceCur = @get('relatedTo.currentRevision.currency')
    amountMax = invoiceCur.toCurrency paymentCur.get('symbol'), @get('relatedTo.balance')
    return amountMax.round(2)
  ).property("relatedTo.balance", "relatedTo.currentRevision.currency.symbol", "currency.symbol")

  updateWithCurrency: (currencyTo) ->
    # Convert amount if `Payment.currency` is 
    # different than `Invoice.currentRevision.currency`
    paymentCurrency = @get('currency')
    invoiceCurrency = @get('relatedTo.currentRevision.currency')

    unless currencyTo.get('symbol') is paymentCurrency.get('symbol')
      amount = invoiceCurrency.fromCurrency paymentCurrency.get('symbol'), @get('amount')
      amount = invoiceCurrency.toCurrency currencyTo.get('symbol'), amount
      @set 'amount', amount.round(2)

    @set 'currency', currencyTo

  didCreate: ->
    message = gettext 'Your payment has been successfully added'
    Vosae.SuccessPopup.open
      message: message
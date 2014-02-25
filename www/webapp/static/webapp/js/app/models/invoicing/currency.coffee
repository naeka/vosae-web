###
  A data model that represents a currency

  @class Currency
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.Currency = Vosae.Model.extend
  symbol: DS.attr('string')
  rates: DS.hasMany('Vosae.ExchangeRate')
  resourceUri: DS.attr('string')

  description: (->
    # Return the description of the current currency
  	obj = Vosae.Config.currenciesDescription.findProperty 'symbol', @get('symbol')
  	if obj and obj.get('description')
  	  return obj.get('description')
  	return ""
  ).property('symbol')

  displaySign: (->
    # The display symbol associated to the currency (e.g. '€', '$', '£').
    # The *symbol* attribute is in the iso4217 format (e.g. 'EUR', 'USD', 'GBP')
    if @get "symbol"
      return Vosae.Config.currenciesSign.findProperty('symbol', @get('symbol')).get('sign')
    return ""
  ).property('symbol')

  displaySignWithSymbol: (->
    # Return the currency sign with symbol
    sign = @get('displaySign')
    symbol = @get('symbol')
    if sign and symbol
      return "#{sign} - #{symbol}"
    console.log sign, symbol
    return ""
  ).property('symbol')

  toCurrency: (currencyTo, amount) ->
    # Convert a `Currency` to another.
    # Based on the current rates.
    if currencyTo is @get('symbol')
      return amount
    return amount * @exchangeRateFor(currencyTo).get('rate')

  fromCurrency: (currencyFrom, amount) ->
    # Convert a `Currency` to another.
    # Based on the current rates.
    if currencyFrom is @get('symbol')
      return amount
    return amount / @exchangeRateFor(currencyFrom).get('rate')

  exchangeRateFor: (symbol) ->
    # Return the rate associated to the specified symbol.
    return @get('rates').findProperty('currencyTo', symbol)


Vosae.Adapter.map "Vosae.Currency",
  rates:
    embedded: 'always'
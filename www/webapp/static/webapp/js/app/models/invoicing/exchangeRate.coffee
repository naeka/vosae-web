###
  A data model that represents an exchange rate

  @class ExchangeRate
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.ExchangeRate = Vosae.Model.extend
  currencyTo: DS.attr('string')
  datetime: DS.attr('datetime')
  rate: DS.attr('number')

Vosae.ExchangeRate = DS.Model.extend
  currencyTo: DS.attr('string')
  datetime: DS.attr('datetime')
  rate: DS.attr('number')

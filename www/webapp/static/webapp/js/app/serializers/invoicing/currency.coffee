Vosae.CurrencySerializer = Vosae.ApplicationSerializer.extend
  attrs:
    rates:
      embedded: 'always'
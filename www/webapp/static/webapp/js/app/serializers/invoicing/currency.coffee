###
  Serializer for model `Vosae.Currency`.

  @class CurrencySerializer
  @extends Vosae.ApplicationSerializer
  @namespace Vosae
  @module Vosae
###

Vosae.CurrencySerializer = Vosae.ApplicationSerializer.extend
  attrs:
    rates:
      embedded: 'always'
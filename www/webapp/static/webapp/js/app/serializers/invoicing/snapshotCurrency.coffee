###
  Serializer for model `Vosae.SnapshotCurrency`.

  @class CurrencySerializer
  @extends Vosae.ApplicationSerializer
  @namespace Vosae
  @module Vosae
###

Vosae.SnapshotCurrencySerializer = Vosae.ApplicationSerializer.extend
  attrs:
    rates:
      embedded: 'always'
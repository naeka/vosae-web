###
  Custom adapter for model `Vosae.Payment`.

  @class PaymentAdapter
  @extends Vosae.ApplicationAdapter
  @namespace Vosae
  @module Vosae
###

Vosae.PaymentAdapter = Vosae.ApplicationAdapter.extend
  ajaxOptions: (url, type, hash) ->
    hash = @_super url, type, hash
    hash.contentType = hash.contentType + "; type=invoice_payment;"
    hash
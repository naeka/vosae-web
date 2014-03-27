###
  Custom adapter for model `Vosae.Tenant`.

  @class TenantAdapter
  @extends Vosae.ApplicationAdapter
  @namespace Vosae
  @module Vosae
###

Vosae.TenantAdapter = Vosae.ApplicationAdapter.extend

  ###
    As long as `supportedCurrencies` and `defaultCurrency` are not part of
    the `<Vosae.Tenant>` model, but are required by the API for creation, 
    this adapter add thoses properties to the `<Vosae.Tenant>` before POST.
  ###
  createRecord: (store, type, record) ->
    data = {}
    serializer = store.serializerFor type.typeKey

    # Dirty but no other solution right now...
    controller = Vosae.lookup('controller:tenants.add')
    
    # Add `supportedCurrencies` and `defaultCurrency` to data
    supportedCurrencies = controller.getSupportedCurrenciesResourceURI()
    defaultCurrency = controller.getDefaultCurrencyResourceURI()

    serializer.serializeIntoHash(data, type, record, includeId: true).then (serialized) =>
      serialized.object['supported_currencies'] = supportedCurrencies
      serialized.object['default_currency'] = defaultCurrency
      @ajax @buildURL(type.typeKey), "POST", data: serialized.object
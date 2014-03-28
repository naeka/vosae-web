# store = null

# describe 'Vosae.InvoicingSettings', ->
#   beforeEach ->
#     comp = getAdapterForTest(Vosae.InvoicingSettings)
#     ajaxUrl = comp[0]
#     ajaxType = comp[1]
#     ajaxHash = comp[2]
#     store = comp[3]

#   afterEach ->
#     comp = undefined
#     ajaxUrl = undefined
#     ajaxType = undefined
#     ajaxHash = undefined
#     store.destroy()

#   it 'supportedCurrencies hasMany relationship', ->
#     # Setup
#     store.adapterForType(Vosae.Currency).load store, Vosae.Currency, {id: 1}
#     store.adapterForType(Vosae.InvoicingSettings).load store, Vosae.InvoicingSettings,
#       id: 1
#       supported_currencies: [
#         "/api/v1/currency/1/"
#       ]
#     currency = store.find Vosae.Currency, 1
#     invoicingSettings = store.find Vosae.InvoicingSettings, 1

#     # Test
#     expect(invoicingSettings.get('supportedCurrencies.firstObject')).toEqual currency

#   it 'defaultCurrency belongsTo relationship', ->
#     # Setup
#     store.adapterForType(Vosae.Currency).load store, Vosae.Currency, {id: 1}
#     store.adapterForType(Vosae.InvoicingSettings).load store, Vosae.InvoicingSettings,
#       id: 1
#       default_currency: "/api/v1/currency/1/"
#     currency = store.find Vosae.Currency, 1
#     invoicingSettings = store.find Vosae.InvoicingSettings, 1

#     # Test
#     expect(invoicingSettings.get('defaultCurrency')).toEqual currency

#   it 'numbering belongsTo embedded relationship', ->
#     # Setup
#     store.adapterForType(Vosae.InvoicingSettings).load store, Vosae.InvoicingSettings,
#       id: 1
#       numbering: {separator: ";"}
#     invoicingSettings = store.find Vosae.InvoicingSettings, 1

#     # Test
#     expect(invoicingSettings.get('numbering.separator')).toEqual ";"

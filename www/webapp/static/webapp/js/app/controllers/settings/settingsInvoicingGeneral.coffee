Vosae.SettingsInvoicingGeneralController = Em.ObjectController.extend
  # Sort currencies by description
  sortedCurrencies: (->
    Ember.ArrayProxy.createWithMixins Ember.SortableMixin,
      sortProperties: ['description']
      content: @get('currencies')
  ).property('currencies')
  
  # Hack 
  supportedCurrencies: (->
    ids = @get('invoicing.supportedCurrencies').getEach('id')
    Vosae.Currency.all().filter (cur) ->
      if ids.contains cur.get('id')
        return cur
  ).property('invoicing.supportedCurrencies.@each.id', 'invoicing.supportedCurrencies.length')

  # Actions handlers
  actions:
    save: (tenantSettings) ->
      tenantSettings.get('transaction').commit()

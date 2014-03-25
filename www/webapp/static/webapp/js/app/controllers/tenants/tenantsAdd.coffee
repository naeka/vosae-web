###
  Custom controller for a `Vosae.Tenant` record.

  @class TenantsAddController
  @extends Ember.ObjectController
  @namespace Vosae
  @module Vosae
###

Vosae.TenantsAddController = Em.ObjectController.extend
  needs: ['tenantsShow']

  supportedCurrencies: []
  defaultCurrency: null
  useBilingAddressAsPostalAddress: true

  # Sort currencies by description
  sortedCurrencies: (->
    Ember.ArrayProxy.createWithMixins Ember.SortableMixin,
      sortProperties: ['description']
      content: @get('currencies')
  ).property('currencies')

  # Return true if user has tenant commited
  hasTenant: (->
    if @get 'tenants'
      length = @get('tenants').filterProperty('isNew', false).get 'length'
      return true if length > 0
    false
  ).property 'tenants.length'

  # Default currency should be empty if not supported currencies
  supportedCurrenciesObserver: (->
    if Em.isEmpty @get('supportedCurrencies')
      @set 'defaultCurrency', null
  ).observes 'supportedCurrencies', 'supportedCurrencies.length'

  # Empty billing address
  resetBillingAddress: (->
    unless @get 'useBilingAddressAsPostalAddress'
      billingAddress = @get 'billingAddress'
      if billingAddress then billingAddress.setProperties
        'streetAddress': ''
        'extendedAddress': ''
        'postalCode': ''
        'postofficeBox': ''
        'city': ''
        'state': ''
        'country': ''
  ).observes 'useBilingAddressAsPostalAddress'

  # Copy postal address values in billing address
  postalAddressObserver: (->
    if @get 'useBilingAddressAsPostalAddress'
      billingAddress = @get 'billingAddress'
      if billingAddress then billingAddress.setProperties
        'streetAddress': @get 'postalAddress.streetAddress'
        'extendedAddress': @get 'postalAddress.extendedAddress'
        'postalCode': @get 'postalAddress.postalCode'
        'postofficeBox': @get 'postalAddress.postofficeBox'
        'city': @get 'postalAddress.city'
        'state': @get 'postalAddress.state'
        'country': @get 'postalAddress.country'
  ).observes(
    'postalAddress.streetAddress',
    'postalAddress.extendedAddress',
    'postalAddress.postalCode',
    'postalAddress.postofficeBox',
    'postalAddress.city',
    'postalAddress.state',
    'postalAddress.country')

  # Returns an array with supported currencies serialized
  getSupportedCurrenciesResourceURI: ->
    array = []
    currencies = @get('supportedCurrencies')
    
    if Em.isEmpty currencies then return []
    currencies.forEach (currency) ->
      array.pushObject currency.get('resourceURI')
    array

  # Returns the default currency serialized 
  getDefaultCurrencyResourceURI: ->
    currency = @get('defaultCurrency')
    if Em.isNone currency
      return null
    currency.get 'resourceURI'

  actions:
    # Post the tenant and get tenantSettings
    save: (tenant) ->
      tenant.one 'didCreate', @, ->
        Ember.run.next @, ->
          if @get('session.tenant')
            @get('controllers.tenantsShow').send "redirectToTenantRoot", tenant
          else
            @get('controllers.tenantsShow').send "setAsCurrentTenant", tenant
      tenant.one 'becameInvalid', @, ->
        Vosae.Utilities.hideLoader()
      tenant.get('transaction').commit()
      Vosae.Utilities.showLoader()

    # Cancel the tenant creation form 
    cancel: ->
      if confirm gettext('Do you realy want to leave this page ?')
        if @get('session.tenant')
          router = Vosae.lookup('router:main')
          router.location.history.back()
        else
          @transitionToRoute 'tenants.show'

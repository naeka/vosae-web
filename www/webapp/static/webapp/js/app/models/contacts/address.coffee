###
  A data model that represents an address

  @class Address
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.VosaeAddress = Vosae.Model.extend
  type: DS.attr("string", defaultValue: 'WORK')
  postofficeBox: DS.attr('string')
  streetAddress: DS.attr('string')
  extendedAddress: DS.attr('string')
  postalCode: DS.attr('string')
  city: DS.attr('string')
  state: DS.attr('string')
  country: DS.attr('string')

  mapAddress: (->
    address = ''
    if @get("streetAddress")
      address = @get("streetAddress")
    if @get("city")
      if address isnt `undefined`
        address += ' ' + @get("city")
      else
        address = @get('city')
    if @get("country")
      if address isnt `undefined`
        address += ' ' + @get("country")
      else
        address = @get('country')
    return address
  ).property('streetAddress', 'city', 'country')

  isEmpty: ->
    # Return true if address is empty
    # if @get 'type'
    #   return false
    if @get 'postofficeBox'
      return false
    if @get 'streetAddress'
      return false
    if @get 'extendedAddress'
      return false
    if @get 'postalCode'
      return false
    if @get 'city'
      return false
    if @get 'state'
      return false
    if @get 'country'
      return false
    return true

  getErrors: ->
    errors = []
    unless @get('streetAddress')
      errors.addObject gettext('Street address field must not be blank')
    return errors

  dumpDataFrom: (address) ->
    if address.constructor.toString() is @constructor.toString()
      @setProperties
        type: address.get 'type'
        postofficeBox: address.get 'postofficeBox'
        streetAddress: address.get 'streetAddress'
        extendedAddress: address.get 'extendedAddress'
        postalCode: address.get 'postalCode'
        city: address.get 'city'
        state: address.get 'state'
        country: address.get 'country'
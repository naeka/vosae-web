###
  A data model that represents an api key

  @class ApiKey
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.ApiKey = Vosae.Model.extend
  label: DS.attr('string')
  key: DS.attr('string') 
  createdAt: DS.attr('datetime')

  didCreate: ->
    message = gettext 'Your API key has been successfully created'
    Vosae.SuccessPopup.open
      message: message

  didDelete: ->
    message = gettext 'Your API key has been successfully deleted'
    Vosae.SuccessPopup.open
      message: message
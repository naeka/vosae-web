###
  A data model that represents an email

  @class Email
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.VosaeEmail = Vosae.Model.extend
  type: DS.attr("string", defaultValue: 'WORK')
  email: DS.attr('string')

  displayType: (->
    obj = Vosae.Config.emailTypeChoice.findProperty('value', @get('type'))
    if obj
      return obj.get('name')
    ''
  ).property()

  getErrors: ->
    errors = []
    unless @get('email')
      errors.addObject gettext('Email field must not be blank')
    return errors
###
  A data model that represents a reminder entry

  @class ReminderEntry
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.ReminderEntry = Vosae.Model.extend
  method: DS.attr('string')
  minutes: DS.attr('number', defaultValue: 10)

  isPopup: (->
    # Returns true if current reminder is a Notification
    return true if @get('method') is 'POPUP'
    false
  ).property('method')

  isEmail: (->
    # Returns true if current reminder is an Email
    return true if @get('method') is 'EMAIL'
    false
  ).property('method')

  displayMethod: (->
    # Returns a formated `role`
    if @get 'method'
      return Vosae.Config.reminderEntries.findProperty('value', @get('method')).get('displayName')
    ''
  ).property 'method'
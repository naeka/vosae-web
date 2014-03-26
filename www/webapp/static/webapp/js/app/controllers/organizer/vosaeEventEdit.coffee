###
  Custom object controller for a `Vosae.VosaeEvent` record.

  @class VosaeEventEditController
  @extends Ember.ObjectController
  @namespace Vosae
  @module Vosae
###

Vosae.VosaeEventEditController = Em.ObjectController.extend
  needs: ['calendarListsShow']

  actions:
    cancel: (vosaeEvent)->
      if vosaeEvent.get('id')
        @transitionToRoute 'vosaeEvent.show', @get('session.tenant'), vosaeEvent
      else
        @transitionToRoute 'calendarLists.show', @get('session.tenant')

    save: (vosaeEvent) ->
      if vosaeEvent.get('isNew')
        message = gettext 'Your event has been successfully created'
      else
        message = gettext 'Your event has been successfully updated'
      vosaeEvent.save().then (vosaeEvent) =>
        Vosae.SuccessPopup.open
          message: message
        @transitionToRoute 'vosaeEvent.show', @get('session.tenant'), vosaeEvent       
    
    delete: (vosaeEvent) ->
      Vosae.ConfirmPopup.open
        message: gettext 'Do you really want to delete this event?'
        callback: (opts, event) =>
          if opts.primary
            vosaeEvent.destroyRecord().then () =>
              Vosae.SuccessPopup.open
                message: gettext 'Your event has been successfully deleted'
              @transitionToRoute 'calendarLists.show', @get('session.tenant')

    addAttendee: ->
      @get('attendees').insertAt(0, @get('store').createRecord('attendee'))

    removeAttendee: (attendee) ->
      Vosae.ConfirmPopup.open
        message: gettext 'Do you really want to delete this attendee?'
        callback: (opts, event) =>
          if opts.primary
            @get('attendees').removeObject(attendee)

    addReminder: ->
      @get('reminders.overrides').pushObject @get('store').createRecord('attendee', {minutes: 10})

    removeReminder: (reminder) ->
      Vosae.ConfirmPopup.open
        message: gettext 'Do you really want to delete this reminder?'
        callback: (opts, event) =>
          if opts.primary
            @get('reminders.overrides').removeObject(reminder)

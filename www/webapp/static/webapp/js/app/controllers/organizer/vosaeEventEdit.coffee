Vosae.VosaeEventEditController = Em.ObjectController.extend
  cancel: (vosaeEvent)->
    if vosaeEvent.get('id')
      @transitionToRoute 'vosaeEvent.show', @get('session.tenant'), vosaeEvent
    else
      @transitionToRoute 'calendarLists.show', @get('session.tenant')

  save: (vosaeEvent) ->
    event = if vosaeEvent.get('id') then 'didUpdate' else 'didCreate'
    vosaeEvent.one event, @, ->
      Ember.run.next @, ->
        if event is 'didCreate'
          message = gettext 'Your event has been successfully created'
        else
          message = gettext 'Your event has been successfully updated'
        Vosae.SuccessPopupComponent.open
          message: message
        @transitionToRoute 'vosaeEvent.show', @get('session.tenant'), vosaeEvent       
    vosaeEvent.get('transaction').commit()
  
  delete: (vosaeEvent) ->
    Vosae.ConfirmPopupComponent.open
      message: gettext 'Do you really want to delete this event?'
      callback: (opts, event) =>
        if opts.primary
          vosaeEvent.one 'didDelete', @, ->
            Ember.run.next @, ->
              Vosae.SuccessPopupComponent.open
                message: gettext 'Your event has been successfully deleted'
              @transitionToRoute 'calendarLists.show', @get('session.tenant')
          vosaeEvent.deleteRecord()
          vosaeEvent.get('transaction').commit()

  addAttendee: ->
    @get('attendees').insertAt(0, Vosae.Attendee.createRecord())

  removeAttendee: (attendee) ->
    Vosae.ConfirmPopupComponent.open
      message: gettext 'Do you really want to delete this attendee?'
      callback: (opts, event) =>
        if opts.primary
          @get('attendees').removeObject(attendee)

  addReminder: ->
    @get('reminders.overrides').pushObject(Vosae.ReminderEntry.createRecord({minutes: 10}))

  removeReminder: (reminder) ->
    Vosae.ConfirmPopupComponent.open
      message: gettext 'Do you really want to delete this reminder?'
      callback: (opts, event) =>
        if opts.primary
          @get('reminders.overrides').removeObject(reminder)

###
  Custom object controller for a `Vosae.CalendarList` record.

  @class CalendarListEditController
  @extends Ember.ObjectController
  @namespace Vosae
  @module Vosae
###

Vosae.CalendarListEditController = Em.ObjectController.extend
  isSaving: false

  areDirty: (->
    if @get('isDirty') or @get('calendar.isDirty')
      return true
    false
  ).property('isDirty', 'calendar.isDirty')

  actions:
    addAclRule: ->
      @get('calendar.acl.rules').createRecord()

    deleteAclRule: (rule) ->
      Vosae.ConfirmPopup.open
        message: gettext 'Do you really want to delete this permission?'
        callback: (opts, event) =>
          if opts.primary
            @get('calendar.acl.rules').removeObject rule

    addReminder: ->
      @get('reminders').createRecord()

    deleteReminder: (reminder) ->
      Vosae.ConfirmPopup.open
        message: gettext 'Do you really want to delete this reminder?'
        callback: (opts, event) =>
          if opts.primary
            @get('reminders').removeObject reminder

    cancel: (calendarList)->
      if calendarList.get('id')
        @transitionToRoute 'calendarList.show', calendarList
      else
        @transitionToRoute 'calendarLists.show'

    save: (calendarList) ->
      calendar = calendarList.get 'calendar'
      @set 'isSaving', true

      # Current user is the owner of the calendar
      if calendarList.get 'isOwn'
        # Creation of a <Vosae.CalendarList> record
        if not calendarList.get 'id'
          calendar.one 'didCreate', @, -> # <Vosae.VosaeCalendar> first
            Ember.run.next @, ->
              calendarList.one 'didCreate', @, -> # Then <Vosae.CalendarList>
                Ember.run.next @, ->
                  @set 'isSaving', false
                  Vosae.SuccessPopup.open
                    message: gettext 'Your calendar has been successfully created'
                  @transitionToRoute 'calendarList.show', @get('session.tenant'), calendarList          
              calendarList.get('transaction').commit()    
          calendar.get('transaction').commit()

        # Edition of a <Vosae.CalendarList>
        else
          # If <Vosae.VosaeCalendar> is dirty
          if calendar.get 'isDirty'
            calendar.one 'didUpdate', @, -> # <Vosae.VosaeCalendar> first
              Ember.run.next @, ->
                # If <Vosae.CalendarList> is dirty
                if calendarList.get 'isDirty'
                  calendarList.one 'didUpdate', @, -> # Then <Vosae.CalendarList>
                    @set 'isSaving', false
                    Vosae.SuccessPopup.open
                      message: gettext 'Your calendar has been successfully updated'
                    @transitionToRoute 'calendarList.show', @get('session.tenant'), calendarList     
                  calendarList.get('transaction').commit()
                else
                  @set 'isSaving', false
                  Vosae.SuccessPopup.open
                    message: gettext 'Your calendar has been successfully updated'
                  @transitionToRoute 'calendarList.show', @get('session.tenant'), calendarList
            calendar.get('transaction').commit()

          # Only <Vosae.CalendarList> is dirty
          else
            calendarList.one 'didUpdate', @, ->
              Ember.run.next @, ->
                @set 'isSaving', false
                Vosae.SuccessPopup.open
                  message: gettext 'Your calendar has been successfully updated'
                @transitionToRoute 'calendarList.show', @get('session.tenant'), calendarList
            calendarList.get('transaction').commit()

      # Current user is not the owner of the calendar
      else
        calendarList.one 'didUpdate', @, ->
          Ember.run.next @, ->
            @set 'isSaving', false
            Vosae.SuccessPopup.open
              message: gettext 'Your calendar has been successfully updated'
            @transitionToRoute 'calendarList.show', @get('session.tenant'), calendarList          
        calendarList.get('transaction').commit()


    delete: (calendarList)->
      Vosae.ConfirmPopup.open
        message: gettext 'Do you really want to delete this calendar?'
        callback: (opts, event) =>
          if opts.primary
            calendarList.destroyRecord().then () =>
              Vosae.SuccessPopup.open
                message: gettext 'Your calendar has been successfully deleted'
              @transitionToRoute 'calendarLists.show'

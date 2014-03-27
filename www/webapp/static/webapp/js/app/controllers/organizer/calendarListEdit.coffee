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
      if calendarList.get('isOwn')
        if calendarList.get('isNew')
           message: gettext 'Your calendar has been successfully created'
        else
           message: gettext 'Your calendar has been successfully updated'
        calendar.save().then (calendar) =>
          calendarList.save().then (calendarList) =>
            @set 'isSaving', false
            Vosae.SuccessPopup.open
              message: gettext 'Your calendar has been successfully created'
            @transitionToRoute 'calendarList.show', @get('session.tenant'), calendarList

      # Current user is not the owner of the calendar
      else
        calendarList.save().then (calendarList) =>
          @set 'isSaving', false
          Vosae.SuccessPopup.open
            message: gettext 'Your calendar has been successfully updated'
          @transitionToRoute 'calendarList.show', @get('session.tenant'), calendarList          


    delete: (calendarList)->
      Vosae.ConfirmPopup.open
        message: gettext 'Do you really want to delete this calendar?'
        callback: (opts, event) =>
          if opts.primary
            calendarList.destroyRecord().then () =>
              Vosae.SuccessPopup.open
                message: gettext 'Your calendar has been successfully deleted'
              @transitionToRoute 'calendarLists.show'

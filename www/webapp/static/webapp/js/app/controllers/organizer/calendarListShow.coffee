###
  Custom object controller for a `Vosae.CalendarList` record.

  @class CalendarListShowController
  @extends Ember.ObjectController
  @namespace Vosae
  @module Vosae
###

Vosae.CalendarListShowController = Em.ObjectController.extend
  delete: (calendarList)->
    Vosae.ConfirmPopupComponent.open
      message: gettext 'Do you really want to delete this calendar?'
      callback: (opts, event) =>
        if opts.primary
          calendarList.one 'didDelete', @, ->
            Ember.run.next @, ->
              Vosae.SuccessPopupComponent.open
                message: gettext 'Your calendar has been successfully deleted'
              @transitionToRoute 'calendarLists.show'
          calendarList.deleteRecord()
          calendarList.get('transaction').commit()

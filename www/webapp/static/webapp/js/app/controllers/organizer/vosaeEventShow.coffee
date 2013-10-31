Vosae.VosaeEventShowController = Em.ObjectController.extend
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

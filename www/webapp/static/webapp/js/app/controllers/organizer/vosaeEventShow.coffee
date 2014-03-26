###
  Custom object controller for a `Vosae.VosaeEvent` record.

  @class VosaeEventShowController
  @extends Ember.ObjectController
  @namespace Vosae
  @module Vosae
###

Vosae.VosaeEventShowController = Em.ObjectController.extend
  actions:
    delete: (vosaeEvent) ->
      Vosae.ConfirmPopup.open
        message: gettext 'Do you really want to delete this event?'
        callback: (opts, event) =>
          if opts.primary
            vosaeEvent.destroyRecord().then () =>
              Vosae.SuccessPopup.open
                message: gettext 'Your event has been successfully deleted'
              @transitionToRoute 'calendarLists.show', @get('session.tenant')

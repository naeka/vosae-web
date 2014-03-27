###
  Custom controller for a `Vosae.User` record.

  @class SettingsEditUserController
  @extends Ember.ObjectController
  @namespace Vosae
  @module Vosae
###

Vosae.SettingsEditUserController = Em.ObjectController.extend
  actions:  
    save: (user) ->
      user.save().then () =>
        @transitionToRoute 'settings.showUsers', @get('session.tenant')

    delete: (user) ->
      Vosae.ConfirmPopup.open
        message: gettext 'Do you really want to delete this user?'
        callback: (opts, event) =>
          if opts.primary
            user.deleteRecord()
            user.save().then () =>
              @transitionToRoute 'settings.showUsers', @get('session.tenant')
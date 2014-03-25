###
  Custom controller for a `Vosae.Group` record.

  @class SettingsEditGroupController
  @extends Ember.ObjectController
  @namespace Vosae
  @module Vosae
###

Vosae.SettingsEditGroupController = Em.ObjectController.extend
  actions:  
    save: (group) ->
      group.save().then () =>
        @transitionToRoute 'settings.showGroups', @get('session.tenant')
    
    delete: (group) ->
      Vosae.ConfirmPopup.open
        message: gettext 'Do you really want to delete this group?'
        callback: (opts, event) =>
          if opts.primary
            group.deleteRecord()
            group.save().then () =>
              @transitionToRoute 'settings.showGroups', @get('session.tenant')

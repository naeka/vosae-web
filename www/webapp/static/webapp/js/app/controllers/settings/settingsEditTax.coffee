###
  Custom controller for a `Vosae.Tax` record.

  @class SettingsEditTaxController
  @extends Ember.ObjectController
  @namespace Vosae
  @module Vosae
###

Vosae.SettingsEditTaxController = Em.ObjectController.extend
  actions:  
    save: (tax) ->
      if tax.checkValidity()
        tax.save().then () =>
          @transitionToRoute 'settings.showTaxes', @get('session.tenant')

    delete: (tax) ->
      Vosae.ConfirmPopup.open
        message: gettext 'Do you really want to delete this tax?'
        callback: (opts, event) =>
          if opts.primary
            tax.deleteRecord()
            tax.save().then () =>
              @transitionToRoute 'settings.showTaxes', @get('session.tenant')

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
        event = if tax.get('id') then 'didUpdate' else 'didCreate'
        tax.one event, @, ->
          Ember.run.next @, ->
            @transitionToRoute 'settings.showTaxes', @get('session.tenant')

        tax.get('transaction').commit()
    
    delete: (tax) ->
      Vosae.ConfirmPopup.open
        message: gettext 'Do you really want to delete this tax?'
        callback: (opts, event) =>
          if opts.primary
            tax.one 'didDelete', @, ->
              Ember.run.next @, ->
                @transitionToRoute 'settings.showTaxes', @get('session.tenant')
            tax.deleteRecord()
            tax.get('transaction').commit()
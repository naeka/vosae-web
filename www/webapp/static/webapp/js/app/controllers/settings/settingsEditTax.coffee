Vosae.SettingsEditTaxController = Em.ObjectController.extend
  save: (tax) ->
    if tax.checkValidity()
      event = if tax.get('id') then 'didUpdate' else 'didCreate'
      tax.one event, @, ->
        Ember.run.next @, ->
          @transitionToRoute 'settings.showTaxes', @get('session.tenant')

      tax.get('transaction').commit()
  
  delete: (tax) ->
    Vosae.ConfirmPopupComponent.open
      message: gettext 'Do you really want to delete this tax?'
      callback: (opts, event) =>
        if opts.primary
          tax.one 'didDelete', @, ->
            Ember.run.next @, ->
              @transitionToRoute 'settings.showTaxes', @get('session.tenant')
          tax.deleteRecord()
          tax.get('transaction').commit()
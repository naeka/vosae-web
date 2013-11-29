Vosae.SettingsEditGroupController = Em.ObjectController.extend
  # Actions handlers
  actions:  
    save: (group) ->
      event = if group.get('id') then 'didUpdate' else 'didCreate'
      group.one event, @, ->
        Ember.run.next @, ->
          @transitionToRoute 'settings.showGroups', @get('session.tenant')
      group.get('transaction').commit()
    
    delete: (group) ->
      Vosae.ConfirmPopupComponent.open
        message: gettext 'Do you really want to delete this group?'
        callback: (opts, event) =>
          if opts.primary
            group.one 'didDelete', @, ->
              Ember.run.next @, ->
                @transitionToRoute 'settings.showGroups', @get('session.tenant')
            group.deleteRecord()
            group.get('transaction').commit()
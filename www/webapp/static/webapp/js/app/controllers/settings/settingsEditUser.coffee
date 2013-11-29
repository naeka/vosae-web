Vosae.SettingsEditUserController = Em.ObjectController.extend
  # Actions handlers
  actions:  
    save: (user) ->
      event = if user.get('id') then 'didUpdate' else 'didCreate'
      user.one event, @, ->
        Ember.run.next @, ->
          @transitionToRoute 'settings.showUsers', @get('session.tenant')

      # Work arround, select multiple groups makes groups 'updated' and add them to buckets
      user.get('groups').forEach (group) ->
        group.rollback() if group.get('isDirty')

      user.get('transaction').commit()

    delete: (user) ->
      Vosae.ConfirmPopupComponent.open
        message: gettext 'Do you really want to delete this user?'
        callback: (opts, event) =>
          if opts.primary
            user.one 'didDelete', @, ->
              Ember.run.next @, ->
                @transitionToRoute 'settings.showUsers', @get('session.tenant')

            # Work arround, select multiple groups makes groups 'updated' and add them to buckets
            user.get('groups').forEach (group) ->
              group.rollback() if group.get('isDirty')

            user.deleteRecord()
            user.get('transaction').commit()
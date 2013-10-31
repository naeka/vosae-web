Vosae.ItemShowController = Ember.ObjectController.extend
  delete: (item) ->
    Vosae.ConfirmPopupComponent.open
      message: gettext 'Do you really want to delete this item?'
      callback: (opts, event) =>
        if opts.primary    
          item.one 'didDelete', @, ->
            Ember.run.next @, ->
              @transitionToRoute 'items.show'
          item.deleteRecord()
          item.get('transaction').commit()
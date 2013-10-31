Vosae.ItemEditController = Em.ObjectController.extend
  cancel: (item) ->
    if item.get('id')
      return @transitionToRoute 'item.show', item
    else
      return @transitionToRoute 'items.show'

  save: (item) ->
    errors = item.getErrors()

    if errors.length
      alert(errors.join('\n'))
    else
      event = if item.get('id') then 'didUpdate' else 'didCreate'
      item.one event, @, ->
        Ember.run.next @, ->
          return @transitionToRoute 'item.show', item

      item.get('transaction').commit()

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
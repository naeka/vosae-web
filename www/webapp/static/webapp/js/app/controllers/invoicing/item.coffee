###
  Custom object controller for a `Vosae.Item` record.

  @class ItemController
  @extends Ember.ObjectController
  @namespace Vosae
  @module Vosae
###

Vosae.ItemController = Em.ObjectController.extend
  actions:
    cancel: (item) ->
      if item.get('id')
        @transitionToRoute 'item.show', item
      else
        @transitionToRoute 'items.show'

    save: (item) ->
      errors = item.getErrors()

      if errors.length
        alert(errors.join('\n'))
      else
        item.save().then (item) =>
          @transitionToRoute 'item.show', item

    delete: (item) ->
      Vosae.ConfirmPopup.open
        message: gettext 'Do you really want to delete this item?'
        callback: (opts, event) =>
          if opts.primary    
            item.deleteRecord()
            item.save().then () =>
              @transitionToRoute 'items.show'
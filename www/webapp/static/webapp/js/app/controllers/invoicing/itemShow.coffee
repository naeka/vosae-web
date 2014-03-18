###
  Custom object controller for a `Vosae.Item` record.

  @class ItemShowController
  @extends Ember.ObjectController
  @namespace Vosae
  @module Vosae
###

Vosae.ItemShowController = Ember.ObjectController.extend
  actions:
    delete: (item) ->
      Vosae.ConfirmPopup.open
        message: gettext 'Do you really want to delete this item?'
        callback: (opts, event) =>
          if opts.primary    
            item.one 'didDelete', @, ->
              Ember.run.next @, ->
                @transitionToRoute 'items.show'
            item.deleteRecord()
            item.get('transaction').commit()
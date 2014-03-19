###
  Set the `Vosae.ApplicationController` as dependencie
  for all controllers.
###

Ember.Controller.reopen
  needs: ['application']

Ember.ObjectController.reopen
  needs: ['application']

Ember.ArrayController.reopen
  needs: ['application']


###
  A custom array controller for Vosae.

  @class ArrayController
  @extends Ember.ArrayController
  @namespace Vosae
  @module Vosae
###

Vosae.ArrayController = Ember.ArrayController.extend
  relatedType: null
  meta: null

  ###
    Make the metadata for the related model available in the templates
  ###
  setMeta: (->
    type = @get "relatedType"
    Ember.Logger.error(@toString() + " needs the `relatedType` property to be defined.") if Em.isNone type
    @set "meta", @store.metadataFor(type)
  ).on "init"

  actions:
    ###
      Fetch more model entries
    ###
    getNextPagination: ->
      type = @get "relatedType"
      meta = @get "meta"
      # If there's metadata and more records to load
      if type and meta.get "canFetchMore"
        meta.set 'loading', true
        # Fetch old timeline entries
        @store.find(type).then =>
          meta.set 'loading', false
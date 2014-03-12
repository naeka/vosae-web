###
  This mixin help us to manage pagination for resources.

  @class MetaMixin
  @extends Ember.Mixin
  @namespace Vosae
  @module Vosae
###

Vosae.MetaMixin = Ember.Mixin.create
  offset: null
  limit: null
  next: null
  previous: null
  totalCount: 0
  loading: false

  hasBeenFetched: (->
    # Return true if model has already been fetched.
    if @get('previous') or @get('offset')?
      return true
    false
  ).property "previous", "offset"

  getNextOffset: ->
    if @get("offset")? then @get("offset") + @get("limit") else 0
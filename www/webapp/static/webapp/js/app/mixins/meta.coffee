###
  This mixin help us to manage pagination for resources.

  @class HelpTourMixin
  @extends Ember.Mixin
  @namespace Vosae
  @module Vosae
###

Vosae.MetaControllerMixin = Ember.Mixin.create
  offset: null
  limit: null
  next: null
  previous: null
  total_count: 0
  loading: false

  totalCount: (->
    @get('total_count')
  ).property('total_count')

  modelHasBeenFetched: (->
    # Return true if model has already been fetched.
    if @get('previous') or @get('offset')?
      return true
    false
  ).property('previous', 'offset')

  getNextOffset: ->
    if @get("offset")? then @get("offset") + @get("limit") else 0
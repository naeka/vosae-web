###
  This mixin fetch statistics.

  @class StatisticsMixin
  @extends Ember.Mixin
  @namespace Vosae
  @module Vosae
###

Vosae.StatisticsMixin = Ember.Mixin.create
  _results: null
  _object: Em.Object.extend 
    content: []

  content: (->
    _results = @get('_results')
    if _results?
      return @get('_object').create(content: _results)
    else
      @fetchResults()
      null
  ).property('_results')

  fetchResults: ->
    adapter = @get('store').adapterFor('application')
    adapter.ajax(adapter.buildURL('statistics'), 'POST',
      data: 
        pipeline: @pipeline()
    ).then (json) =>
      @set('_results', json['objects'])

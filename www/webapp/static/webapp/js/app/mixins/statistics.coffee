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
    _this = @
    adapter = @get('store.adapter')
    adapter.ajax(adapter.buildURL('statistics'), 'POST',
      data:
        pipeline: _this.pipeline()
    ).then((json) ->
      _this.set('_results', json['objects'])
    )

Vosae.MetaController = Ember.Mixin.create
  offset: null
  limit: null
  next: null
  previous: null
  total_count: 0
  loading: false

  totalCount: (->
    return @get('total_count')
  ).property('total_count')

  modelHasBeenFetched: (->
    # Return true if model has already been fetched.
    if @get('previous') or @get('offset')?
      return true
    return false
  ).property('previous', 'offset')

  getNextOffset: ->
    if @get('offset') is null
      return 0
    else 
      return @get('offset') + @get('limit')
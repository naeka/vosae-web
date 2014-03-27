Vosae.TimelineAdapter = Vosae.ApplicationAdapter.extend
  find: (store, type, id) ->
    @ajax @buildURL("timeline", id), 'GET'
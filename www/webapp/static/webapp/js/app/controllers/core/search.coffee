###
  Custom controller that manage search on application

  @class SearchController
  @extends Ember.ArrayController
  @namespace Vosae
  @module Vosae
###

Vosae.SearchController = Ember.ArrayController.extend
  searchIsActive: false
  minSearchTerms: 2
  insufficientSearchTerms: false
  queryString: null
  
  ###
    Create a search with the passing query
  ###
  createSearchQuery: (string) ->
    adapter = @get('store.adapter')
    self = this

    if string.length < @get("minSearchTerms")
      @set "insufficientSearchTerms", true
      @set "searchIsActive", true
    else
      @set "insufficientSearchTerms", false
      @set "queryString", string
      adapter.ajax(adapter.buildURL('search'), "GET",
        data: "q=" + string + "&limit=4"
      ).then((json) ->
        self.generateGetters json["objects"] if json["objects"].length > 0
        self.set "content", json["objects"]
        self.set "searchIsActive", true
      ).then null, adapter.rejectionHandler

  ###
    Generate a get method for each object
  ###
  generateGetters: (objects) ->
    i = 0
    while i < objects.length
      objects[i].get = (property) ->
        this[property]
      i++
    objects[0].isFirstObject = true
    return

  ###
    Reset the query
  ###
  resetSearchQuery: ->
    @setProperties
      "searchIsActive": false
      "content": []
    return

###
  Custom array controller for a collection of <Vosae.Timeline> based records.

  @class DashboardShowController
  @extends Ember.ArrayController
  @uses Vosae.TransitionToLazyResourceMixin
  @namespace Vosae
  @module Vosae
###

Vosae.DashboardIndexController = Vosae.ArrayController.extend Vosae.TransitionToLazyResourceMixin,
  relatedType: "timeline"
  sortProperties: ['datetime']
  sortAscending: false

  actions:
    ###
      Fetch more timeline entries
    ###
    getNextPagination: ->
      meta = @get "meta"

      # If there's metadata and there's more records to load
      if meta.get "canFetchMore"
        length = @getTimelineEntriesLength()
        meta.set 'loading', true
        # Fetch old timeline entries
        @store.find('timeline').then =>
          if length > 0 then @updateContentFrom(length - 1) else @updateContent()
          meta.set 'loading', false

  mergedRecordArrays: (->
    mergedRecordArrays = []
    @get("unmergedContent").forEach (recordArray) ->
      mergedRecordArrays = mergedRecordArrays.concat recordArray.get("content").toArray()
    @set "content", mergedRecordArrays
    @updateContent()
  ).observes "unmergedContent.length", "unmergedContent.@each.length"

  ###
    Get the length of each recordArray and sum each length. @unmergedContent is an array 
    of recordArray, each recordArray match a polymorphic model such as `ContactSavedTE`
  ###
  getTimelineEntriesLength: ->
    @get("unmergedContent").getEach("length").reduce (previousLength, currentLength) ->
      previousLength + currentLength

  ###
    Traverse timeline items
  ###
  updateContent: ->
    now = moment()
    currentDate = moment([now.year(), now.month(), now.day()])
    length = @get('content.length')

    i = 0
    while i < length
      item = @objectAt(i)
      itemDate = item.get "datetime"
      itemDate = moment([itemDate.getFullYear(), itemDate.getMonth(), itemDate.getDay()])
  
      # Compare dates and set dateChanged if different
      if currentDate.unix() isnt itemDate.unix()
        item.set "dateChanged", true
        currentDate = itemDate

      else
        item.set "dateChanged", false

        if i > 0
          # If previous item has same module
          if @objectAt(i-1).get("issuer.id") is @objectAt(i).get("issuer.id")
            item.set "sameIssuer", true
            # If previous item has same module
            if @objectAt(i-1).get("module") is @objectAt(i).get("module")
              item.set "sameModule", true
            else
              item.set "sameModule", false 
          else
            item.set "sameIssuer", false
      i++
      
    if @get("arrangedContent.firstObject")    
      @get("arrangedContent.firstObject").set "isFirst", true

    return

  ###
    Traverse timeline items
  ###
  updateContentFrom: (startIndex, stopIndex) ->
    i = startIndex
    z = if stopIndex? then stopIndex else @get('arrangedContent.length')

    if @get('arrangedContent.length') > 1
      currentDate = @get('arrangedContent').objectAt(startIndex).get "datetime"
      currentDate = moment([
        currentDate.getFullYear()
        currentDate.getMonth()
        currentDate.getDay()
      ])

      while i < z
        item = @get('arrangedContent').objectAt(i)
        item.set "isFirst", false

        itemDate = item.get "datetime"
        itemDate = moment([itemDate.getFullYear(), itemDate.getMonth(), itemDate.getDay()])
        
        # Compare dates and set dateChanged if different
        if currentDate.unix() isnt itemDate.unix()
          item.set "dateChanged", true
          currentDate  = itemDate
        else
          item.set "dateChanged", false
          # If previous item has same module
          if @objectAt(i-1) and @objectAt(i-1).get("issuer.id") is @objectAt(i).get("issuer.id")
            item.set "sameIssuer", true
            # If previous item has same module
            if @objectAt(i-1).get("module") is @objectAt(i).get("module")
              item.set "sameModule", true
            else
              item.set "sameModule", false 
          else
            item.set "sameIssuer", false
        i++

    if @get("arrangedContent.firstObject")    
      @get("arrangedContent.firstObject").set "isFirst", true

    return
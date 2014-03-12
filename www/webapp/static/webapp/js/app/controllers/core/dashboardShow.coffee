###
  Custom array controller for a collection of <Vosae.Timeline> based records.

  @class DashboardShowController
  @extends Ember.ArrayController
  @uses Vosae.TransitionToLazyResourceMixin
  @namespace Vosae
  @module Vosae
###

Vosae.DashboardShowController = Ember.ArrayController.extend Vosae.TransitionToLazyResourceMixin,
  sortProperties: ['datetime']
  sortAscending: false
  meta: null

  mergedRecordArrays: (->
    mergedRecordArrays = []
    @get("unmergedContent").forEach (recordArray) ->
      mergedRecordArrays = mergedRecordArrays.concat recordArray.get("content").toArray()
    @set "content", mergedRecordArrays
  ).observes("unmergedContent", "unmergedContent.length", "unmergedContent.@each", "unmergedContent.@each.length")
  
  # setMeta: (->
  #   @set 'meta', Vosae.metaForTimeline
  #   if @get('meta') and !@get('meta.modelHasBeenFetched')
  #     @send("getNextPagination")
  # ).on "init"

  # actions:
    ###
      Pagination retrieve older items
    ###
    # getNextPagination: ->
      # pagination = null

      # if @get('meta') and !@get('meta.loading')
      #   if @get('meta.next') or !@get('meta.modelHasBeenFetched')
      #     offset = if @get('meta.offset')? then @get('meta.offset') + @get('meta.limit') else 0
      #     pagination =
      #       data: Vosae.Timeline.find(offset: offset)
      #       offset: @get('meta.offset')
      #       limit: @get('meta.limit')
      #       lastLength: Vosae.Timeline.all().get('length')
          
      #     @set 'meta.loading', true

      #     if pagination and pagination.data  
      #       pagination.data.one 'didLoad', @, ->
      #         Ember.run @, ->
      #           @set 'content', Vosae.Timeline.all() # Workaround
      #           if pagination.lastLength > 0
      #             startIndex = pagination.lastLength - 1
      #             @updateContentFrom(startIndex)
      #           else
      #             @updateContent()

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
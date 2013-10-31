###
  This mixin help to create infinite scroll view. `paginationAction()` 
  method is called when user reached the bottom of the page.

  @class InfiniteScroll
  @namespace Vosae
  @module Vosae
###
Vosae.InfiniteScroll = Ember.Mixin.create
  paginationAction: Em.K
  offset: 100

  init: ->
    @_super()
    @_createPagination()

  willDestroy: ->
    @_super()
    @_destroyPagination()

  _createPagination: ->
    $(window).scroll =>
      if $(window).scrollTop() >= $(document).height() - $(window).height() - @get('offset')
        @paginationAction() 

  _destroyPagination: ->
    $(window).unbind "scroll"
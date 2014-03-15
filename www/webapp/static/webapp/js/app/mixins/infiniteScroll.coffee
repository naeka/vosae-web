###
  This mixin help us to create infinite scroll view. `paginationAction()` 
  method is called when user reached the bottom of the page.

  @class InfiniteScrollMixin
  @extends Ember.Mixin
  @namespace Vosae
  @module Vosae
###

Vosae.InfiniteScrollMixin = Ember.Mixin.create
  classNames: ["infinite-scroll"]
  paginationAction: Em.K
  offset: 100
  infiniteScrollSelector: null

  didInsertElement: ->
    @setupInfiniteScrollListener()

  willDestroy: ->
    @teardownInfiniteScrollListener()

  teardownInfiniteScrollListener: ->
    $(@infiniteScrollSelector).unbind("scroll")

  setupInfiniteScrollListener: ->
    selector = @infiniteScrollSelector

    $(selector).scroll Vosae.Utilities.debounce(=>
      if $(selector).scrollTop() >= $(document).height() - $(window).height() - @offset
        @send("paginationAction")
    , 100)

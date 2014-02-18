###
  This mixin help us to create infinite scroll view. `paginationAction()` 
  method is called when user reached the bottom of the page.

  @class InfiniteScrollMixin
  @extends Ember.Mixin
  @namespace Vosae
  @module Vosae
###

Vosae.InfiniteScrollMixin = Ember.Mixin.create
  paginationAction: Em.K
  offset: 160

  initScrollSpy: (->
    $(window).scroll Vosae.Utilities.debounce(=>
      if $(window).scrollTop() >= $(document).height() - $(window).height() - @offset
        @send("paginationAction")
    , 100)
  ).on "init"

  willDestroy: ->
    $(window).unbind "scroll"
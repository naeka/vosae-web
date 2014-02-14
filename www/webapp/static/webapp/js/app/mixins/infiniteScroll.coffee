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
  offset: 100

  initScrollPagination: (->
    $(window).scroll =>
      if $(window).scrollTop() >= $(document).height() - $(window).height() - @get('offset')
        @paginationAction()
  ).on "init"

  disableScrollPagination: (->
    $(window).unbind "scroll"
  ).on "willDestroy"

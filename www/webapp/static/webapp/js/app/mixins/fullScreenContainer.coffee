###
  This mixin automaticaly adapt a container size with the
  window width and height.

  @class FullScreenContainerMixin
  @extends Ember.Mixin
  @namespace Vosae
  @module Vosae
###

Vosae.FullScreenContainerMixin = Ember.Mixin.create
  outletContainerID: null

  checkContainerID: (->
    outletContainerID = @get "outletContainerID"
    Em.assert "The `outletContainerID` property is mandatory for the Vosae.FullScreenContainerMixin", !!outletContainerID
  ).on "init"

  enableResizeEvent: (->
    eventName = "resize.#{@get('outletContainerID')}"
    $(window)
      .on(eventName, => @resizeOutletContainer())
      .trigger(eventName)
      .find("body").css("overflow", "hidden")
    $("#" + @get("outletContainerID")).show()
  ).on "didInsertElement"

  disableResizeEvent: (->
    eventName = "resize.#{@get('outletContainerID')}"
    $(window)
      .off(eventName)
      .find("body").css("overflow", "auto")
    $("#ct-middle").click()
    $("#" + @get("outletContainerID")).hide()
  ).on "willDestroyElement"

  resizeOutletContainer: ->
    $("#" + @get("outletContainerID")).css
      "height": $(window).outerHeight()
      "width": $(window).outerWidth()
###
  This mixin automaticaly adapt a container size with the
  window width and height.

  @class FullScreenContainer
  @namespace Vosae
  @module Vosae
###
Vosae.FullScreenContainer = Ember.Mixin.create
  outletContainerId: null

  init: ->
    @_super()
    outletContainerId = @get "outletContainerId"
    Em.assert "The `outletContainerId` property is mandatory when Vosae.FullScreenContainer mixin", !!outletContainerId

  didInsertElement: ->
    eventName = "resize.#{@get('outletContainerId')}"
    $(window)
      .on(eventName, => @resizeOutletContainer())
      .trigger(eventName)
      .find("body").css("overflow", "hidden")
    $("#" + @get("outletContainerId")).show()

  willDestroyElement: ->
    eventName = "resize.#{@get('outletContainerId')}"
    $(window)
      .off(eventName)
      .find("body").css("overflow", "auto")
    $("#ct-middle").click()
    $("#" + @get("outletContainerId")).hide()

  resizeOutletContainer: ->
    $("#" + @get("outletContainerId")).css
      "height": $(window).outerHeight()
      "width": $(window).outerWidth()
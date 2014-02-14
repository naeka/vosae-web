###
  A base view that gives common functionality

  @class View
  @extends Ember.View
  @namespace Vosae
  @module Vosae
###
Vosae.View = Ember.View.extend()

Vosae.View.reopenClass
  
  ###
    Register a view helper for ease of use
    
    @method registerHelper
    @param {String} helperName the name of the helper
    @param {Ember.View} helperClass the view that will be inserted by the helper
  ###
  registerHelper: (helperName, helperClass) ->
    Ember.Handlebars.registerHelper helperName, (options) ->
      hash = options.hash
      types = options.hashTypes
      Vosae.Utilities.normalizeHash hash, types
      Ember.Handlebars.helpers.view.call this, helperClass, options
    return

  ###
    Returns an observer that will re-render if properties change. This is useful for
    views where rendering is done to a buffer manually and need to know when to trigger
    a new render call.
    
    @method renderIfChanged
    @params {String} propertyNames*
    @return {Function} observer
  ###
  renderIfChanged: ->
    args = Array::slice.call(arguments_, 0)
    args.unshift ->
      @rerender()
      return
    Ember.observer.apply this, args
###
  This component used moment.js to show 'createdAt' times
  in 'time ago' format.

  @class FromNowComponent
  @extends Ember.Component
  @namespace Vosae
  @module Vosae
###

Vosae.FromNowComponent = Ember.Component.extend
  tagName: "time"
  template: Ember.Handlebars.compile("{{view.output}}")

  initTick: (->
    @tick()
  ).on "init"

  output: (->
    moment(@get("value")).fromNow()
  ).property("value")

  cancelTick: (->
    nextTick = @get "nextTick"
    Ember.run.cancel nextTick
  ).on "willDestroyElement"

  tickInterval: ->
    diff = Math.abs(moment() - moment(@get("value")))
    switch
      when diff < 45e3 then 1e3  # Update every second
      when diff < 2700e3 then 60e3  # Update every minute
      when diff < 79200e3 then 3600e3  # Update every hour
      else 86400e3  # Update every day

  tick: ->
    nextTick = Ember.run.later this, ->
      @notifyPropertyChange "value"
      @tick()
    , @tickInterval()
    @set "nextTick", nextTick

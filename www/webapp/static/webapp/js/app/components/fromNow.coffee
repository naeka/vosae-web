###
  This component used moment.js to show 'createdAt' times
  in 'time ago' format.

  @class FromNowView
  @namespace Vosae
  @module Components
###

Vosae.Components.FromNowView = Ember.View.extend
  tagName: "time"
  template: Ember.Handlebars.compile("{{view.output}}")

  output: (->
    moment(@get("value")).fromNow()
  ).property("value")

  tickInterval: ->
    diff = Math.abs(moment() - moment(@get("value")))
    switch
      when diff < 45e3 then 1e3  # Update every second
      when diff < 2700e3 then 60e3  # Update every minute
      when diff < 79200e3 then 3600e3  # Update every hour
      else 86400e3  # Update every day

  didInsertElement: ->
    @tick()

  tick: ->
    nextTick = Ember.run.later this, ->
      @notifyPropertyChange "value"
      @tick()
    , @tickInterval()
    @set "nextTick", nextTick

  willDestroyElement: ->
    nextTick = @get "nextTick"
    Ember.run.cancel nextTick

Ember.Handlebars.helper "fromNow", Vosae.Components.FromNowView
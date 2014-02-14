###
  This render a time picker

  @class TimePicker
  @extends Ember.ContainerView
  @namespace Vosae
  @module Vosae
###

Vosae.TimePicker = Ember.ContainerView.extend
  classNames: ['bootstrap-timepicker']
  childViews: [Em.TextField]

  timepicker_settings:
    disableFocus: true
    showMeridian: not /[H]+/.test moment.langData()._longDateFormat.LT

  didInsertElement: ->
    @$(':first-child').addClass('edit')
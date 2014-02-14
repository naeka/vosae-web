###
  This render a date picker

  @class DatePicker
  @extends Ember.TextField
  @namespace Vosae
  @module Vosae
###

Vosae.DatePicker = Em.TextField.extend
  datepicker_settings:
    autoclose: true

  setLanguage: (->
    @datepicker_settings.language = Vosae.currentLanguage
  ).on "init"

  removeDatePicker: (->
    @$().datepicker "remove"
  ).on "willDestroyElement"

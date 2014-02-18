###
  This mixin automatically grow and shrink textareas or input with the content 
  as you type. It must be applied on a `TextField` or `TextArea` class.

  @class AutoGrowMixin
  @extends Ember.Mixin
  @namespace Vosae
  @module Vosae
###

Vosae.AutoGrowMixin = Ember.Mixin.create
  initAutoGrow: (->
    @$()
      .on 'change', (ev)->
        $(this).autoGrow(0)
      .autoGrow(0)
  ).on "didInsertElement"

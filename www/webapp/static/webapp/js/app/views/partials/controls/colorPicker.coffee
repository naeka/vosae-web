###
  This render a color picker based on jQuery minicolors.

  @class ColorPicker
  @extends Ember.TextField
  @namespace Vosae
  @module Vosae
###

Vosae.ColorPicker = Ember.TextField.extend
  initMiniColors: (->
    @$().minicolors()
  ).on "didInsertElement"
  
  destroyMiniColors: (->
    @$().minicolors('destroy')
  ).on "willDestroyElement"

Vosae.View.registerHelper "color-picker", Vosae.ColorPicker
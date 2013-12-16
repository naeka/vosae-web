###
  This component display a customised color picker based on jQuery minicolors

  @class ColorPicker
  @namespace Vosae
  @module Components
###

Vosae.Components.ColorPicker = Em.TextField.extend
  didInsertElement: ->
    @$().minicolors()
  
  willDestroyElement: ->
    @$().minicolors('destroy')
    @_super()
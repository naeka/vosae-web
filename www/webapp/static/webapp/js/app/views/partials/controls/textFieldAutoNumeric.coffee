###
  This automatically formats currency and numbers as you type on form inputs.

  @class TextFieldAutoNumeric 
  @extends Ember.TextField
  @namespace Vosae
  @module Vosae
###

Vosae.TextFieldAutoNumeric = Ember.TextField.extend
  aSep: accounting.settings.number.thousand
  aDec: accounting.settings.number.decimal
  wEmpty: 'zero'

  initAutoNumeric: (->
    @$().autoNumeric 'init',
      aSep: @get('aSep')
      aDec: @get('aDec')
      wEmpty: @get('wEmpty')
  ).on "didInsertElement"

  destroyAutoNumeric: (->
    @$().autoNumeric 'destroy'
  ).on "willDestroyElement"

Vosae.View.registerHelper "input-autonumeric", Vosae.TextFieldAutoNumeric
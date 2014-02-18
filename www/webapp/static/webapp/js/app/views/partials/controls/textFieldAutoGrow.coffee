###
  This automatically grow and shrink input with the content 
  as you type.

  @class TextFieldAutoGrow
  @extends Ember.TextField
  @uses Vosae.AutoGrowMixin
  @namespace Vosae
  @module Vosae
###

Vosae.TextFieldAutoGrow = Em.TextField.extend Vosae.AutoGrowMixin

Vosae.View.registerHelper "input-autogrow", Vosae.TextFieldAutoGrow
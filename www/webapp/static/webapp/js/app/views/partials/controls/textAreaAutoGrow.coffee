###
  This automatically grow and shrink textarea with the content 
  as you type.

  @class TextAreaAutoGrow
  @extends Ember.TextField
  @uses Vosae.AutoGrowMixin
  @namespace Vosae
  @module Vosae
###

Vosae.TextAreaAutoGrow = Em.TextArea.extend Vosae.AutoGrowMixin

Vosae.View.registerHelper "textarea-autogrow", Vosae.TextAreaAutoGrow
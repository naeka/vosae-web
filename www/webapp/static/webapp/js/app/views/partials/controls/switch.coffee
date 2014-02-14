###
  This view render a switch button that toggle a property

  @class SwitchView
  @extends Ember.View
  @namespace Vosae
  @module Vosae
###

Vosae.SwitchView = Em.View.extend
  classNames: ["onoffswitch-container"]
  checkboxId: null
  defaultTemplate: Ember.Handlebars.compile('
    <div class="onoffswitch">
      {{view view.checkbox checkedBinding="view.checked"}}
      <label class="onoffswitch-label" for="">
        <div class="onoffswitch-inner"></div>
        <div class="onoffswitch-switch"></div>
      </label>
    </div>')

  checkbox: Em.Checkbox.extend
    classNames: ["onoffswitch-checkbox"]
    setAttributeFor: (->
      @get("parentView").$().find("label").attr "for", @get("elementId")
    ).on "didInsertElement" 

Vosae.View.registerHelper "switch", Vosae.SwitchView
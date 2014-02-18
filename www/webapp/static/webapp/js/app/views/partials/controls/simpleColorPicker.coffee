###
  Todo

  @class SimpleColorPicker
  @extends Ember.View
  @namespace Vosae
  @module Vosae
###

Vosae.SimpleColorPicker = Ember.View.extend
  classNames: ['color-picker']
  colors: [null, '#dcf85f', '#c7f784', '#a3d7ea', '#ffa761', '#eb5f3a', '#74a31e', '#44b2ae', '#7f54c0', '#390a59']
  value: null
  defaultTemplate: Ember.Handlebars.compile('{{#each view.colors}}{{view view.colorEntry colorBinding="this"}}{{/each}}')

  pushInitialValue: (->
    if @get('value') and @get('value').toLowerCase() not in @get('colors')
      @get('colors').push @get('value')
  ).on "init"

  colorEntry: Em.View.extend
    tagName: 'a'
    classNames: ['color-entry']
    classNameBindings: ['selected']

    color: null
    selected: (->
      if @get('parentView.value') and @get('parentView.value').toLowerCase() is @get('color')
        return true
      else if @get('parentView.value') is null and @get('color') is null
        return true
      false
    ).property('parentView.value')

    didInsertElement: ->
      color = @get('color')
      if color
        if Color(color).luminosity() < 0.5
          textColor = '#fefefe'
        @$().css 'background-color', color
        @$().css 'border-color', Color(color).darken(0.3).hexString()
        if textColor
          @$().css 'color', textColor
      else
        @$()
          .addClass('no-color')
          .prop 'title', pgettext('calendar color', 'None')

    click: ->
      @set('parentView.value', @get('color'))

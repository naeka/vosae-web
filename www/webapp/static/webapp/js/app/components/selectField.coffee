###
  This component display a customised select element

  @class Select
  @namespace Vosae
  @module Components
###

Vosae.Components.Select = Em.Select.extend
  hideSearchField: true
  dropdownCssClass: ''
  containerCssClass: ''
  width: 'auto'
  dropdownAutoWidth: true
  allowClear: false

  # Default select2 format result
  formatResult: (result, container, query, escapeMarkup, select2) ->
    result.text

  # Default select2 format selection
  formatSelection: (data, container) ->
    if data then data.text else `undefined`

  didInsertElement: ->
    if not @get('controller.controllers.application').isTouchDevice()
      _this = @
      @$().select2
        placeholder: @get('prompt')
        width: @get('width')
        dropdownAutoWidth: @get('dropdownAutoWidth')
        allowClear: @get('allowClear')

        # Overide container css classes
        containerCssClass: (clazz) =>
          if @get 'containerCssClass'
            clazz = clazz + ' ' + @get 'containerCssClass'
          return clazz

        # Overide dropdown css classes
        dropdownCssClass: (clazz) =>
          if @get 'hideSearchField'
            clazz = "#{clazz} no-search"
          if @get 'dropdownCssClass'
            clazz = clazz + ' ' + @get 'dropdownCssClass'
          clazz

        # Default format result
        formatResult: (result, container, query, escapeMarkup) =>
          @formatResult result, container, query, escapeMarkup
        
        # Default format selection
        formatSelection: (data, container) =>
          @formatSelection data, container
  
  willDestroyElement: ->
    @$().select2('destroy')
    @_super()
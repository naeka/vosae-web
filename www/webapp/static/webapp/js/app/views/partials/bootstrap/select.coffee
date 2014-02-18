###
  This component display a customised select element

  @class Select
  @namespace Bootstrap
  @module Forms
###

Bootstrap.Forms.Select = Bootstrap.Forms.Field.extend
  # Default properties
  optionLabelPath: 'content'
  optionValuePath: 'content'

  # Select2 properties
  hideSearchField: true
  dropdownCssClass: ''
  containerCssClass: ''
  dropdownAutoWidth: true
  allowClear: false
  width: 'auto'

  inputField: Ember.Select.extend
    contentBinding: 'parentView.content'

    optionLabelPathBinding: 'parentView.optionLabelPath'
    optionValuePathBinding: 'parentView.optionValuePath'

    valueBinding: 'parentView.value'
    selectionBinding: 'parentView.selection'
    promptBinding: 'parentView.prompt'
    multipleBinding: 'parentView.multiple'
    disabledBinding: 'parentView.disabled'
    classNameBindings: ['parentView.inputClassNames']

    hideSearchFieldBinding: 'parentView.hideSearchField'
    dropdownCssClassBinding: 'parentView.dropdownCssClass'
    containerCssClassBinding: 'parentView.containerCssClass'
    widthBinding: 'parentView.width'
    dropdownAutoWidthBinding: 'parentView.dropdownAutoWidth'
    allowClearBinding: 'parentView.allowClear'

    name: (->
      this.get('parentView.name') or this.get('parentView.label')
    ).property('parentView.name', 'parentView.label')

    # Default select2 format result
    formatResult: (result, container, query, escapeMarkup, select2) ->
      result.text

    # Default select2 format selection
    formatSelection: (data, container) ->
      if data then data.text else `undefined`

    didInsertElement: ->
      @$().select2
        placeholder: @get('prompt')
        width: @get('width')
        dropdownAutoWidth: @get('dropdownAutoWidth')
        allowClear: @get('allowClear')

        # Overide container css classes
        containerCssClass: (clazz) =>
          if @get 'containerCssClass'
            clazz += " #{@get('containerCssClass')}"
          return clazz

        # Overide dropdown css classes
        dropdownCssClass: (clazz) =>
          if @get 'hideSearchField'
            clazz += "#{clazz} no-search"
          if @get 'dropdownCssClass'
            clazz += " #{@get('dropdownCssClass')}"
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
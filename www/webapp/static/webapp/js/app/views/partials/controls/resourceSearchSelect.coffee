###
  This generic select allow us to generate an ajax request on 
  a specific resource endpoint when user is typing his query.
  Example: /api/search/&q=tom&types=user

  @class ResourceSearchField
  @extends Ember.TextField
  @namespace Vosae
  @module Components
###

Vosae.ResourceSearchSelect = Ember.TextField.extend
  type: 'hidden'

  # Properties
  resourceType: null
  maximumSelectionSize: 1
  minimumInputLength: 2
  dropdownAutoWidth: true
  containerCssClass: ''
  dropdownCssClass: ''
  width: 'auto'
  noMatchesTemplate: Handlebars.compile(gettext('No results for "{{term}}"'))
  allowClear: false

  # Hook
  initSelection: Em.K
  formatResult: Em.K
  formatSelection: Em.K
  formatSelectionTooBig: Em.K
  formatNoMatches: Em.K
  onSelect: Em.K
  onRemove: Em.K
  focusIn: Em.K
  focusOut: Em.K

  ajax: ->
    dict = 
      url: Vosae.lookup('store:main').get('adapter').buildURL('search')
      type: 'GET',
      quietMillis: 100,
      data: (term, page) =>
        query = "q=#{term}"
        resourceType = @get('resourceType')
        if typeIsArray resourceType
          resourceType.forEach (type) ->
            query += "&types=#{type}"
        else
          query += "&types=#{resourceType}"
        query
      results: (data, page) =>
        results: data["objects"]

  didInsertElement: ->
    # Init
    @.$().select2
      placeholder: @get 'placeholder'
      maximumSelectionSize: @get 'maximumSelectionSize'
      minimumInputLength: @get 'minimumInputLength'
      dropdownAutoWidth: @get 'dropdownAutoWidth'
      ajax: @ajax()
      width: @get('width')
      allowClear: @get('allowClear')

      initSelection: (element, callback) =>
        @initSelection element, callback

      formatResult: (result) =>
        @formatResult result
      
      formatSelection: (result) =>
        @formatSelection result

      formatInputTooShort: (input, min) =>
        if @formatInputTooShort?
          return @formatInputTooShort input, min
        remainingChars = min - input.length
        Handlebars.compile(ngettext("Please enter 1 more character", "Please enter {{remainingChars}} more characters", remainingChars))({remainingChars: remainingChars})
      
      formatSelectionTooBig: (maxSize) =>
        @formatSelectionTooBig maxSize
      
      formatNoMatches: (term) =>
        @noMatchesTemplate(term: term)
      
      containerCssClass: (clazz) =>
        clazz = clazz + ' resource-search-field'
        if @get 'containerCssClass'
          clazz = clazz + ' ' + @get 'containerCssClass'
        clazz
      
      dropdownCssClass: (clazz) =>
        clazz = clazz + ' resource-search-field'
        if @get 'dropdownCssClass'
          clazz = clazz + ' ' + @get 'dropdownCssClass'
        clazz

    # Events
    @.$()
      .on 'select2-selecting', (e) =>
        @onSelect e
      .on 'select2-focus', (e) =>
        @focusIn e
      .on 'select2-blur', (e) =>
        @focusOut e
      .on 'select2-removed', (e) =>
        @onRemove e
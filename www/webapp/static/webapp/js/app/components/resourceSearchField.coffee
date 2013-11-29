###
  This generic component display a select with ajax autocomplete 
  on a specific resource endpoint like '/api/contacts/'

  @class ResourceSearchField
  @namespace Vosae
  @module Components
###

Vosae.Components.ResourceSearchField = Em.TextField.extend
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
                    
# Search field for model <Vosae.Organization>
Vosae.Components.OrganizationSearchField = Vosae.Components.ResourceSearchField.extend
  resourceType: 'organization'

  formatResult: (organization) ->
    "<div title='#{organization.corporate_name}'>#{organization.corporate_name}</div>"

  formatSelection: (organization) ->
    organization.corporate_name

  formatSelectionTooBig: (maxSize) ->
    gettext 'Only one organization can be selected'

  # formatNoMatches: (term) ->
  #   span = @noMatchesTemplate({term: term})
  #   text = gettext 'Create an organization'
  #   link = Ember.View.Create
  #     template: Ember.Handlebars.compile "{{#linkTo 'contacts.add' controller.session.tenant}}#{text}{{/linkTo}}"
  #     controller: @get 'controller'
  #   return span

# Search field for model <Vosae.Contact>
Vosae.Components.ContactSearchField = Vosae.Components.ResourceSearchField.extend
  resourceType: 'contact'

  formatResult: (contact) ->
    "<div title='#{contact.full_name}'>#{contact.full_name}</div>"

  formatSelection: (contact) ->
    contact.full_name

  formatSelectionTooBig: (maxSize) ->
    gettext 'Only one contact can be selected'


# Search field for model <Vosae.Item>
Vosae.Components.ItemSearchField = Vosae.Components.ResourceSearchField.extend
  resourceType: 'item'

  formatResult: (item) ->
    description = item.description.split('\n')[0]
    "<div title='#{item.description}'>[#{item.reference}] #{description}</div>"

  formatSelection: (item) ->
    item.reference

  formatSelectionTooBig: (maxSize) ->
    gettext 'Only one item can be selected'


# Search field for model <Vosae.User> and <Vosae.Group>
Vosae.Components.AclEntitySearchField = Vosae.Components.ResourceSearchField.extend
  # resourceType: ['user', 'group']
  resourceType: 'user'
  containerCssClass: 'calendarList-acl-entity'

  formatResult: (obj) ->
    "<div title='#{obj.full_name}'>#{obj.full_name}</div>"

  formatSelection: (obj) ->
    obj.full_name

  formatSelectionTooBig: (maxSize) ->
    gettext 'Only one user or group can be selected'

  formatNoMatches: (term) ->
    "<span>" + gettext("No results for '#{term}'") + "</span>"

# Search field for model <Vosae.Tax>
Vosae.Components.TaxSearchField = Vosae.Components.ResourceSearchField.extend
  resourceType: 'tax'

  ajax: ->
    object = 
      url: Vosae.lookup('store:main').get('adapter').buildURL('search')
      type: 'GET',
      quietMillis: 100,
      data: (term, page) =>
        "q=#{term}"
      results: (data, page) =>
        objects = $.map Vosae.Tax.all().toArray(), (obj) ->
          id: obj.get('id')
          display_tax: obj.get('displayTax')
        results: objects

  formatResult: (tax) ->
    "<div title='#{tax.display_tax}'>#{tax.display_tax}</div>"

  formatSelection: (tax) ->
    tax.display_tax

  formatSelectionTooBig: (maxSize) ->
    gettext 'Only one tax can be selected'

Vosae.CalendarSelectOption = Em.SelectOption.extend
  defaultTemplate: (context, options)->
    options = 
      data: options.data
      hash: {}
    Ember.Handlebars.helpers.bind.call(context, "view.label", options);

Vosae.InvoiceBaseEditBillingAddressBlock = Em.View.extend
  templateName: 'invoicebase-edit-billing-address-block'
  classNames: 'invoicebase-edit-billing-address-block'

Vosae.InvoiceBaseEditSenderAddressBlock = Em.View.extend
  templateName: 'invoicebase-edit-sender-address-block'
  classNames: 'invoicebase-edit-sender-address-block'
  content: null



##
# Custom typeahead field for models
#
Vosae.TypeaheadField = Em.TextField.extend
  minLength: 2
  items: 5
  property: 'name'

  didInsertElement: ->
    self = @

    @$().vosaetypeahead(
      minLength: self.get("minLength")
      items: self.get("items")
      property: self.get("property")

      source: (typeahead, query) ->
        return self.source(typeahead, query)

      onselect: (obj) ->
        return self.onSelect(obj)
    )

  onSelect: (obj) ->
    throw new Error("Typeahead field error: You need to overide the 'onSelect' method.")

  source: (typeahead, query) ->
    throw new Error("Typeahead field error: You need to overide the 'source' method.")
 
  willDestroyElement: ->
    @.$().vosaetypeahead 'destroy'




Vosae.SimpleColorPickerField = Em.View.extend
  classNames: ['color-picker']
  
  colors: [null, '#dcf85f', '#c7f784', '#a3d7ea', '#ffa761', '#eb5f3a', '#74a31e', '#44b2ae', '#7f54c0', '#390a59']
  value: null
  
  defaultTemplate: Ember.Handlebars.compile('{{#each view.colors}}{{view view.colorEntry colorBinding="this"}}{{/each}}')

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

  init: ->
    @_super()
    if @get('value') and @get('value').toLowerCase() not in @get('colors')
      @get('colors').push @get('value')
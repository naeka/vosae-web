# =====================================
# = Vosae ember common forms elements =
# =====================================

Vosae.FlipSwitchButton = Em.View.extend
  templateName: 'flipswitch'
  classNames: ["onoffswitch-container"]
  checkboxId: null

  checkbox: Em.Checkbox.extend
    classNames: ["onoffswitch-checkbox"]
    didInsertElement: ->
      @get('parentView').$().find('label').attr('for', @get('elementId'))


Vosae.StyledGreenSelect = Em.Select.extend
  init: ->
    @_super()
    
    if @get('prompt')    
      @select2Settings =
        minimumResultsForSearch: 6
        placeholder: @get('prompt')
    else
      @select2Settings =
        minimumResultsForSearch: 6

  didInsertElement: ->
    @$().select2(@select2Settings) unless @get('controller.controllers.application').isTouchDevice()
  
  willDestroyElement: ->
    @$().select2('destroy')
    @_super()


Vosae.CalendarSelectOption = Em.SelectOption.extend
  defaultTemplate: (context, options)->
    options = 
      data: options.data
      hash: {}
    Ember.Handlebars.helpers.bind.call(context, "view.label", options);


Vosae.InvoiceBaseShowAddressBlock = Em.View.extend
  templateName: 'invoicebase-show-address-block'
  classNames: 'invoicebase-show-address-block'
  content: null

Vosae.InvoiceBaseEditBillingAddressBlock = Em.View.extend
  templateName: 'invoicebase-edit-billing-address-block'
  classNames: 'invoicebase-edit-billing-address-block'

Vosae.InvoiceBaseEditSenderAddressBlock = Em.View.extend
  templateName: 'invoicebase-edit-sender-address-block'
  classNames: 'invoicebase-edit-sender-address-block'
  content: null

Vosae.TextAreaAutoSize = Em.TextArea.extend
  didInsertElement: ->
    @$().autosize()

Vosae.AutoCompleteField = Em.TextField.extend
  labelKey: 'label'
  valueKey: 'value'
  minLength: 0
  autoFocus: false
  source: [{ label: "Choice1", value: "value1" }, { label: "Choice2", value: "value2" }]

  didInsertElement: ->
    self = this
    @.$().autocomplete
      autoFocus: @get('autoFocus')
      minLength: @get('minLength')
      source: @get('source')
      focus: (event, ui) ->
        self.$().val(ui.item.label)
        return false
      select: (event, ui) ->
        self.$().val(ui.item.label)
        return true
  willDestroyElement: ->
    @.$().autocomplete('destroy')


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

Vosae.AutoNumericField = Em.TextField.extend
  aSep: accounting.settings.number.thousand
  aDec: accounting.settings.number.decimal
  wEmpty: 'zero'

  didInsertElement: ->
    @.$().autoNumeric 'init',
      aSep: @get('aSep')
      aDec: @get('aDec')
      wEmpty: @get('wEmpty')

  willDestroyElement: ->
    @.$().autoNumeric 'destroy'


Vosae.DateField = Em.TextField.extend
  type: "date"


Vosae.DateTimeField = Em.TextField.extend
  type: "datetime"


Vosae.TimeField = Em.TextField.extend
  type: "time"


Vosae.DatePickerField = Em.TextField.extend
  datepicker_settings:
    autoclose: true

  init: ->
    @_super()
    @datepicker_settings.language = Vosae.currentLanguage

  willDestroyElement: ->
    @$().datepicker "remove"

Vosae.TimePickerField = Em.ContainerView.extend
  classNames: ['bootstrap-timepicker']
  childViews: [Em.TextField]

  timepicker_settings:
    disableFocus: true
    showMeridian: not /[H]+/.test moment.langData()._longDateFormat.LT

  didInsertElement: ->
    @$(':first-child').addClass('edit')


Vosae.AutoGrowMixin = Ember.Mixin.create
  didInsertElement: ->
    @_super()
    @$()
      .on 'change', (ev)->
        $(this).autoGrow(0)
      .autoGrow(0)

Vosae.AutoGrowTextField = Em.TextField.extend
  didInsertElement: ->
    @$().autoGrow(0)


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


# This manager is used to render all permissions
# in a template and bind it with `permissions`
# of a <Vosae.Group> instance

Vosae.PermissionsManager = Em.View.extend
  templateName: 'edit-permissions-block'
  allPermissions: Vosae.permissions

  # This view helps us to render permissions 
  # in template grouped by module

  permissionsModuleView: Em.View.extend
    templateName: 'edit-permissions-module-block'

    permSwitchButton: Vosae.FlipSwitchButton.extend
      checkbox: Em.Checkbox.extend
        classNames: ["onoffswitch-checkbox"]
        freezeCheckedObserver: false

        didInsertElement: ->
          @get('parentView').$().find('label').attr('for', @get('elementId'))

          @setPerm()
          @addCheckedObserver()

          # This observer should be fired only when user want to load
          # permissions from a <Vosae.Group> into the current group
          group = @get('parentView.group')
          group.on "permissionsHasBeenLoaded", @, ->
            @set('freezeCheckedObserver', true)
            @setPerm()
            @set('freezeCheckedObserver', false)

        setPerm: ->
          perm = @get('parentView.perm')
          permissions = @get('parentView.group.permissions')

          if permissions.contains(perm)
            @set('checked', true)
          else
            @set('checked', false)

        addCheckedObserver: ->
          @addObserver 'checked', ->
            if not @get('freezeCheckedObserver')
              perm = @get('parentView.perm')
              group = @get('parentView.group')
              permissions = @get('parentView.group.permissions')

              if @get('checked')
                if not permissions.contains(perm)
                  permissions.addObject(perm)
              else
                if permissions.contains(perm)
                  permissions.removeObject(perm)
              if group.get 'id'
                group.set 'currentState', DS.RootState.loaded.updated.uncommitted
              else
                group.set 'currentState', DS.RootState.loaded.created.uncommitted

        destroy: ->
          @removeObserver('checked')
          @_super()


# This manager is used to render all permissions in
# a template and bind it with `permissions` and
# `specificPermissions` of a <Vosae.User> instance

Vosae.SpecificPermissionsManager = Em.View.extend
  templateName: 'edit-specific-permissions-block'
  allPermissions: Vosae.permissions

  # This view helps us to render permissions 
  # in template grouped by module
  
  specificPermissionsModuleView: Em.View.extend
    templateName: 'edit-specific-permissions-module-block'

    permSwitchButton: Vosae.FlipSwitchButton.extend
      checkbox: Em.Checkbox.extend
        classNames: ["onoffswitch-checkbox"]
        freezeCheckedObserver: false

        setPerm: ->
          perm = @get('parentView.perm')
          specificPermissions = @get('parentView.specificPermissions')
          user = specificPermissions.get('owner')
          specificPerm = user.specificPermissionsContains(perm)

          if user.permissionsContains(perm)
            if specificPerm
              if specificPerm.get('value')
                @set('checked', true)
              else
                @set('checked', false)
            else
              @set('checked', true)

          else
            if specificPerm
              if specificPerm.get('value')
                @set('checked', true)
              else
                @set('checked', false)
            else
              @set('checked', false)

        addCheckedObserver: ->
          @addObserver 'checked', ->
            if not @get('freezeCheckedObserver')
              perm = @get('parentView.perm')
              specificPermissions = @get('parentView.specificPermissions')
              user = specificPermissions.get('owner')
              specificPerm = user.specificPermissionsContains(perm)

              if specificPerm
                specificPerm.toggleProperty('value')
              else
                specificPermissions.createRecord(name: perm, value: @get('checked'))

        didInsertElement: ->
          @get('parentView').$().find('label').attr('for', @get('elementId'))

          @setPerm()
          @addCheckedObserver()

          # Get user from `specificPermisisons` hasMany
          # This observer should be fired only when `groups` of 
          # the current <Vosae.User> has been updated
          user = @get('parentView.specificPermissions.owner')
          user.on "groupsHasBeenMerged", @, ->
            @set('freezeCheckedObserver', true)
            @setPerm()
            @set('freezeCheckedObserver', false)

        destroy: ->
          @removeObserver('checked')
          @_super()


Vosae.ArraySortPropertySelect = Em.View.extend
  selectedSortProperty: null
  templateName: "array-sort-property-select"
  classNames: ["btn-group"]

  init: ->
    @_super()
    
    if @sortProperties
      sortProperty = @get('content').filterProperty('value', @sortProperties.toString())
      if sortProperty then @set('selectedSortProperty', sortProperty[0].get('label'))

  didInsertElement: ->
    @.$().find('.dropdown-toggle').dropdown()

  changeSortProperty: (sortProperty) ->
    if sortProperty
      @set('sortProperties', [sortProperty.get('value')])
      @set('selectedSortProperty', sortProperty.get('label'))
  
  clearSortProperty: ->
    @set('sortProperties', [''])
    @set('selectedSortProperty', null)


Vosae.ArraySortAscendingSelect = Em.View.extend
  selectedSortAscending: null
  templateName: "array-sort-ascending-select"
  classNames: ["btn-group"]

  init: ->
    @_super()
    
    value = (if @sortAscending then true else false)
    ascending = @get('content').filterProperty('value', value)

    @set('selectedSortAscending', ascending[0].get('label'))

  didInsertElement: ->
    @.$().find('.dropdown-toggle').dropdown()

  changeSortAscending: (ascending) ->
    if ascending
      @set('sortAscending', ascending.get('value'))
      @set('selectedSortAscending', ascending.get('label'))
  
  clearSortAscending: ->
    @set('sortAscending', [''])
    @set('selectedSortAscending', null)

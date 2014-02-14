Vosae.CalendarListEditView = Em.View.extend
  classNames: ["app-organizer", "page-edit-calendar"]

  calendarListColorField: Vosae.Select.extend
    dropdownCssClass: 'calendarList-color'
    content: Vosae.calendarListColors
    optionLabelPath: 'content.displayName'
    optionValuePath: 'content.value'
    prompt: gettext 'Color'

    # Format each colors entry
    formatResult: (result, container, query, escapeMarkup, select2) ->
      colorBack = result.id
      colorBord = Color(colorBack).darken(0.3).hexString()
      markup = "<span style='background-color: #{colorBack}; border-color: #{colorBord};'></span> #{result.text}"  

    # Format selected color
    formatSelection: (data, container) ->
      data.text

    didInsertElement: ->
      @_super()
      
      color = @get 'value'
      if color
        @$().parent().find('.select2-choice').css 'background', color

    change: (ev) ->
      @$().parent().find('.select2-choice').css 'background', ev.val


  aclEntitySearchField: Vosae.UserSearchSelect.extend
    onSelect: (event) ->
      rule = @get 'rule'
      user = Vosae.User.find(event.object.id)
      
      if user.get 'isLoaded'
        rule.set 'principal', user
      else
        user.one 'didLoad', ->
          rule.set 'principal', user
    
    # When field is rendered check if the <Vosae.CalendarAclRule> is linked to a <Vosae.User>
    didInsertElement: ->
      @_super()

      principal = @get 'rule.principal'

      if principal
        if principal.get('isLoaded')
          @.$().select2 'data',
            id: principal.get 'id'
            full_name: principal.get 'fullName'
          @.$().select2 'val', principal.get('id')
        else
          principal.one "didLoad", @, ->
            @.$().select2 'data',
              id: principal.get 'id'
              full_name: principal.get 'fullName'
            @.$().select2 'val', principal.get('id')


  aclRuleRolesField: Vosae.Select.extend
    containerCssClass: 'calendarList-acl-role'
    content: Vosae.calendarAclRuleRoles
    optionLabelPath: 'content.displayName'
    optionValuePath: 'content.value'

    # Format each colors entry
    formatResult: (result) ->
      result.text

    # Format selected color
    formatSelection: (data) ->
      data.text

    onSelect: (event) ->

    didInsertElement: ->
      @_super()


  reminderMethodField: Vosae.Select.extend
    containerCssClass: 'green reminder-method'
    content: Vosae.reminderEntries
    optionLabelPath: 'content.displayName'
    optionValuePath: 'content.value'

    formatResult: (result) ->
      result.text

    formatSelection: (data) ->
      data.text

    onSelect: (event) ->

    didInsertElement: ->
      @_super()


Vosae.CalendarListEditSettingsView = Em.View.extend Vosae.HelpTourMixin,
  classNames: ["page-settings", "page-edit-calendar-settings"]

  initHelpTour: ->
    helpTour = @_super()

    helpTour.addStep
      element: ".summary"
      title: gettext "Calendar name (required field)"
      content: gettext "This is <i>the name of the calendar</i>. Add the name and the description of your calendar. For example <strong>Work</strong>, <strong>Private</strong>, <strong>My Amazing Project</strong> etc."
      placement: "bottom"

    helpTour.addStep
      element: ".color"
      title: gettext "Calendar color"
      content: gettext "You can select a color for your calendar. This allows you to see it and find it faster."
      placement: "left"

    helpTour.addStep
      element: ".timezone"
      title: gettext "Timezone"
      content: gettext "You can select a timezone for your calendar."
      placement: "left"
   
    helpTour.addStep
      element: ".helptour-calendar-reminders"
      title: gettext "Event reminders"
      content: gettext "From here you can define the default reminders of your calendar. Then, when you will create an event in this calendar, these reminders will be used. By default there are no reminders."
      placement: "top"

    helpTour.addStep
      element: ".helptour-calendar-sharing"
      title: gettext "Sharing (required field)"
      content: gettext "You can choose to share your calendar with <strong><i>Vosae</i> users</strong>. It's for example very useful to work with your colleagues. You can set right to <strong>Read</strong>, <strong>Write</strong>, <strong>Own</strong> or <strong>None</strong>"
      placement: "top"
      

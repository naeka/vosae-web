Vosae.CalendarListEditView = Em.View.extend
  classNames: ["app-organizer", "page-edit-calendar"]

  aclEntitySearchField: Vosae.Components.AclEntitySearchField.extend

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

  aclRuleRolesField: Vosae.Components.CalendarListAclRuleRolesField.extend
    onSelect: (event) ->

    didInsertElement: ->
      @_super()

  reminderMethodField: Vosae.Components.ReminderMethodField.extend
    onSelect: (event) ->

    didInsertElement: ->
      @_super()

Vosae.CalendarListEditSettingsView = Em.View.extend Vosae.HelpTour,
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
      

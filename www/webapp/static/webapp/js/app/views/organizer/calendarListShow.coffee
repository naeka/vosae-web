Vosae.CalendarListShowView = Em.View.extend
  classNames: ["app-organizer", "page-show-calendar"]

Vosae.CalendarListShowSettingsView = Em.View.extend Vosae.HelpTour,
  classNames: ["page-settings", "page-show-calendar-settings"]

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
      

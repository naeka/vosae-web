Vosae.OrganizationsShowView = Em.View.extend
  classNames: ["app-contacts", "page-content", "page-list-organizations"]


Vosae.OrganizationsShowSettingsView = Em.View.extend Vosae.HelpTour,
  classNames: ["app-contacts", "page-settings", "page-list-organization-settings"]

  initHelpTour: ->
    helpTour = @_super()

    helpTour.addStep
      element: ".page-list-organizations .helptour-organizations"
      title: gettext "Organizations page"
      content: gettext "This is the <strong>Organization's</strong> page. On this page <i>Vosae</i> lists all of your organizations. It's a useful way of sorting your contacts. You can view them by company or by group."
      placement: "right"

    helpTour.addStep
      element: ".page-list-organizations .helptour-allcontacts"
      title: gettext "See all contacts"
      content: gettext "To <i>see all your contacts</i> just click on this link."
      placement: "right"

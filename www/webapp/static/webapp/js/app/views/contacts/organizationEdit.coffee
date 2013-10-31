Vosae.OrganizationEditView = Vosae.EntityEditView.extend
  classNames: ["app-contacts", "page-edit-contact", "page-edit-organization",]

Vosae.OrganizationEditSettingsView = Em.View.extend Vosae.HelpTour,
  classNames: ["app-contacts", "page-edit-organization-settings", "page-settings"]

  initHelpTour: ->
    helpTour = @_super()

    helpTour.addStep
      element: ".page-edit-organization .corporate-name input"
      title: gettext "Organization's information (required field)"
      content: gettext "This is the name of the <strong>Organization</strong>. It's used in <strong>Quotations</strong> or <strong>Invoices</strong>."
      placement: "right"
    
    helpTour.addStep
      element: ".page-edit-organization .addresses"
      title: gettext "Addresses"
      content: gettext "Add the address of the <strong>Organization</strong> and <i>Vosae</i> will show you a detailed map of the location. The address is particularly useful for invoicing, <i>Vosae</i> will fill everything in for you!"
      placement: "left"
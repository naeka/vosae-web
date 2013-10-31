Vosae.ContactEditView = Vosae.EntityEditView.extend
  classNames: ["app-contacts", "page-edit-contact"]

Vosae.ContactEditSettingsView = Em.View.extend Vosae.HelpTour,
  classNames: ["app-contacts", "page-edit-contact-settings", "page-settings"]

  initHelpTour: ->
    helpTour = @_super()

    helpTour.addStep
      element: ".page-edit-contact .infos"
      title: gettext "Contact informations (required field)"
      content: gettext "This is the <strong>Contact's</strong> information. Add his <i>First name</i> and <i>Last name</i> as well as his <i>Role</i> (e.g. CEO, Product Manager, etc.)."
      placement: "right"

    helpTour.addStep
      element: ".page-edit-contact .organization .select2-container"
      title: gettext "Organization"
      content: gettext "If you have created at least one <strong>Organization</strong>, you can add the contact to it. It's the perfect way to easily organise and find your contacts."
      placement: "left"
    
    helpTour.addStep
      element: ".page-edit-contact .addresses"
      title: gettext "Addresses"
      content: gettext "Add the address of the <strong>Contact</strong> and <i>Vosae</i> will show you a detailed map of the location. The address is particularly useful for invoicing, <i>Vosae</i> will fill everything in for you!"
      placement: "left"
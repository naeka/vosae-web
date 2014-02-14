Vosae.InvoicingDashboardView = Em.View.extend
  classNames: ["page-invoicing-dashboard"]

Vosae.InvoicingDashboardSettingsView = Em.View.extend Vosae.HelpTourMixin,
  classNames: ["page-invoicing-dashboard-settings", "page-settings"]

  initHelpTour: ->
    helpTour = @_super()

    helpTour.addStep
      element: ".app-invoicing .helptour-dashboardtab"
      title: gettext "Invoicing Dashboard"
      content: gettext "This is your <strong>Invoicing</strong> dashboard. It is the main view for the <strong>Invoicing</strong> application."
      placement: "right"

    helpTour.addStep
      element: ".app-invoicing .helptour-righttab"
      title: gettext "Others Dashboard"
      content: gettext "From these tabs you can quickly navigate to your <strong>Invoices</strong>, <strong>Quotations</strong> and <strong>Items</strong>."
      placement: "left"
    
    helpTour.addStep
      element: ".page-invoicing-dashboard .summary"
      title: gettext "Summary (not yet implemented)"
      content: gettext "This provides an overview of your invoicing, accompanied by informative statistics."
      placement: "top"

    helpTour.addStep
      element: ".page-invoicing-dashboard .helptour-addbtn"
      title: gettext "Add buttons"
      content: gettext "It's the right place to quickly add an <strong>Invoice</strong>, <strong>Quotation</strong> or <strong>Item</strong>!"
      placement: "right"

    helpTour.addStep
      element: ".page-invoicing-dashboard .invoices"
      title: gettext "Last entries"
      content: gettext "From here, you can see and access the last <strong>Overdue invoices</strong> and <strong>Quotes to bill</strong>."
      placement: "top"

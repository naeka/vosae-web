Vosae.QuotationEditView = Vosae.InvoiceBaseEditView.extend
  classNames: ["page-edit-quotation"]

  quotationDateField: Vosae.DatePickerField.extend
    didInsertElement: ->
      @_super()
      element = @$().closest('.invoice-head .date')

      date = @get('currentRevision.quotationDate')
      if date?
        element.attr 'data-date', moment(date).format("L")

      element
        .datepicker(@datepicker_settings)
        .on "changeDate", (ev) =>
          @get("currentRevision").set "quotationDate", ev.date
          element.datepicker 'hide'

  quotationValidityField: Vosae.DatePickerField.extend
    didInsertElement: ->
      @_super()
      element = @$().closest('.invoice-head .validity')
      defaultValidityDays = @get('parentView.controller.session.tenantSettings.invoicing.quotationValidity')

      date = @get('currentRevision.quotationValidity')
      if date instanceof Date
        element.attr 'data-date', moment(date).format("L")
      else if defaultValidityDays?
        # Current date + defaultValidity days (30 by default)
        date = moment().add("days", defaultValidityDays)
        @get("currentRevision").set "quotationValidity", date._d
        element.attr 'data-date', date.format("L")

      element
        .datepicker(@datepicker_settings)
        .on "changeDate", (ev) =>
          @get("currentRevision").set "quotationValidity", ev.date
          element.datepicker 'hide'

Vosae.QuotationEditSettingsView = Em.View.extend Vosae.HelpTour,
  classNames: ["app-invoice", "page-edit-quotation-settings", "page-settings"]

  initHelpTour: ->
    helpTour = @_super()

    helpTour.addStep
      element: ".page-edit-quotation .transmitter"
      title: gettext "The transmitter (required field)"
      content: gettext "This is the quotation transmitter, <i>Vosae</i> makes it quicker by automatically filling it with the relevant info."
      placement: "right"
   
    helpTour.addStep
      element: ".page-edit-quotation .helptour-receiver"
      title: gettext "The receiver (required field)"
      content: gettext "And on the right, the quotation receiver. This is the <strong>Organization</strong> you want to quote. For greater efficiency, after you have added the organization and the contact in the <strong>Contact</strong> application, all you have to do is start typing, press Enter and <i>Vosae</i> will do the rest for you."
      placement: "left"

    helpTour.addStep
      element: ".page-edit-quotation .informations .helptour-datecreated"
      title: gettext "Quotation date (required field)"
      content: gettext "The date on which the quotation was created. <i>Vosae</i> will insert the current date by default but you can edit it by clicking here."
      placement: "right"

    helpTour.addStep
      element: ".page-edit-quotation .informations .validity"
      title: gettext "Valid until (required field)"
      content: gettext "The <i>valid until</i> date is extremely useful, both for your customers and also for you. <i>Vosae</i> will notify you when a quotation becomes outdated."
      placement: "right"

    helpTour.addStep
      element: ".invoice-base-title"
      title: gettext "Quotation reference (auto-generated)"
      content: gettext "The quotation reference is based on your <strong>Settings</strong> (see <strong>Numbering</strong> part) and is automatically added to your quotation once you have saved it."
      placement: "top"

    helpTour.addStep
      element: ".page-edit-quotation .table-line-items"
      title: gettext "Quotation items (at least one is required)"
      content: gettext "This is the most important part of a quotation. You can insert any item previously added in your <strong>Items</strong> page."
      placement: "top"

    helpTour.addStep
      element: ".page-edit-quotation .invoice-content .pull-right"
      title: gettext "Currency (required)"
      content: gettext "With <i>Vosae</i> you can make a quotation in a range of currencies. You just have to select the desired currency and <i>Vosae</i> will convert it."
      placement: "left"

    helpTour.addStep
      element: ".page-edit-quotation .invoice-actions .helptour-create"
      title: gettext "Create"
      content: gettext "Once your quotation is complete, click on the <strong>Create</strong> button. <i>Vosae</i> will save it as a draft."
      placement: "top"

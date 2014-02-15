Vosae.InvoiceEditView = Vosae.InvoiceBaseEditView.extend Vosae.SortableLineItemsMixin,
  classNames: ["page-edit-invoice"]

  invoicingDateField: Vosae.DatePicker.extend
    didInsertElement: ->
      @_super()
      element = @$().closest('.invoice-head .date')

      date = @get 'currentRevision.invoicingDate'
      if date?
        element.attr 'data-date', moment(date).format("L")
      
      element
        .datepicker(@datepicker_settings)
        .on "changeDate", (ev) =>
          @get("currentRevision").set "invoicingDate", ev.date
          element.datepicker 'hide'
          conditions = Vosae.Config.paymentConditions.findProperty("value", @get('controller.session.tenantSettings.invoicing.paymentConditions'))
          if not @get("currentRevision").get "dueDate"
            @get("currentRevision").set "dueDate", Vosae.Config.paymentConditions.getDueDate(ev.date, conditions)
          else
            if confirm gettext("Also update payment due date?")
              @get("currentRevision").set "dueDate", Vosae.Config.paymentConditions.getDueDate(ev.date, conditions)

  dueDateBlockView: Ember.View.extend
    templateName: "invoice/edit/_dueDateBlock"
    classNames: ["due-date clearfix"]

    currentPaymentConditions: (->
      dueDate = @get 'currentRevision.dueDate'
      invoicingDate = @get 'currentRevision.invoicingDate'
      if dueDate?
        if invoicingDate?
          for conditions in Vosae.Config.paymentConditions
            expectedDueDate = Vosae.Config.paymentConditions.getDueDate invoicingDate, conditions
            if moment(dueDate).isSame expectedDueDate, 'day'
              return conditions
        return
      else
        return Vosae.Config.paymentConditions.findProperty 'value', @get('controller.session.tenantSettings.invoicing.paymentConditions')
    ).property()

    isCustom: (->
      if @get('currentPaymentConditions') and @get('currentPaymentConditions.value') is 'CUSTOM'
        return true
      return false
    ).property('currentPaymentConditions')

    dueDateField: Vosae.DatePicker.extend
      didInsertElement: ->
        @_super()
        element = @$().closest('.invoice-legal .date')

        date = @get 'currentRevision.dueDate'
        if date?
          element.attr 'data-date', moment(date).format("L")
        
        element
          .datepicker(@datepicker_settings)
          .on "changeDate", (ev) =>
            @get("currentRevision").set "dueDate", ev.date

    paymentConditionsField: Vosae.Select.extend
      change: (ev)->
        conditions = @get('selection')
        invoicingDate = @get 'currentRevision.invoicingDate'
        if conditions is null or conditions.get('value') is 'CUSTOM' or not invoicingDate
          return
        dueDate = Vosae.Config.paymentConditions.getDueDate invoicingDate, conditions
        @set 'currentRevision.dueDate', dueDate.toDate()

Vosae.InvoiceEditSettingsView = Em.View.extend Vosae.HelpTourMixin,
  classNames: ["app-invoice", "page-edit-invoice-settings", "page-settings"]

  initHelpTour: ->
    helpTour = @_super()

    helpTour.addStep
      element: ".page-edit-invoice .transmitter"
      title: gettext "The transmitter (required field)"
      content: gettext "This is the <strong>Invoice</strong> transmitter, <i>Vosae</i> automatically makes it easier by filling it with your information."
      placement: "right"
   
    helpTour.addStep
      element: ".page-edit-invoice .helptour-receiver"
      title: gettext "The receiver (required field)"
      content: gettext "And on the right, the <strong>Invoice</strong> receiver. This is the <strong>Organization</strong> you want to bill. For greater efficiency, after you have added the organization and the contact in the <strong>Contact</strong> application, all you have to do is start typing, press Enter and <i>Vosae</i> will do the rest for you."
      placement: "left"

    helpTour.addStep
      element: ".page-edit-invoice .informations .helptour-datecreated"
      title: gettext "Invoicing date (required field)"
      content: gettext "The date on which the <strong>Invoice</strong> was created. <i>Vosae</i> will insert the current date by default but you can edit it by clicking."
      placement: "right"

    helpTour.addStep
      element: ".page-edit-invoice .invoice-legal .date"
      title: gettext "Due date (required field)"
      content: gettext "The <i>due date</i> is extremely useful, both for your customers and also for you. <i>Vosae</i> will notify you when an invoice becomes outdated."
      placement: "top"

    helpTour.addStep
      element: ".invoice-base-title"
      title: gettext "Invoicing reference (auto-generated)"
      content: gettext "The invoice reference is based on your <strong>Settings</strong> (see <strong>Numbering</strong> part) and is automatically added to your invoice once you have saved it."
      placement: "top"

    helpTour.addStep
      element: ".page-edit-invoice .table-line-items"
      title: gettext "Invoice items (at least one is required)"
      content: gettext "This is the most important part of an invoice. You can insert any item previously added in your <strong>Items</strong> page."
      placement: "top"

    helpTour.addStep
      element: ".page-edit-invoice .invoice-content .pull-right"
      title: gettext "Currency (required)"
      content: gettext "With <i>Vosae</i> you can invoice in a range of currencies. You just have to select the desired currency and <i>Vosae</i> will convert it."
      placement: "left"

    helpTour.addStep
      element: ".page-edit-invoice .invoice-actions .helptour-create"
      title: gettext "Create"
      content: gettext "Once your invoice is completed, click on the <strong>Create</strong> button. <i>Vosae</i> will save it as a draft."
      placement: "top"

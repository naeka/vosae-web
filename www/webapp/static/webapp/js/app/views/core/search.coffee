Vosae.SearchView = Em.View.extend
  templateName: "search"
  elementId: "desktop-search-results"

  showSearchResults: (->
    if @get("controller.controllers.search.searchIsActive") is true
      @$().trigger("zoneFocus")
    else
      $("#ct-middle").trigger("zoneFocus")
  ).observes("controller.controllers.search.searchIsActive")

  resultDisplayView: Em.View.extend
    templateName: "desktop-search-result"
    tagName: "li"
    classNames: ["result"]
    classNameBindings : ["item.isFirstObject:active"]
    
    click: ->
      item = @get('item')
      store = @get('controller.store')

      if item
        switch item.resource_type
          # Contact
          when "contact"
            $("#ct-middle").trigger("zoneFocus")
            if item.id
              @get('controller').transitionToRoute 'contact.show', store.find('contact', item.id)
          # Organization
          when "organization"
            $("#ct-middle").trigger("zoneFocus")
            if item.id
              @get('controller').transitionToRoute 'organization.show', store.find('organization', item.id)
          # Invoice
          when "invoice"
            $("#ct-middle").trigger("zoneFocus")
            if item.id
              @get('controller').transitionToRoute 'invoice.show', store.find('invoice', item.id)
          # Quotation
          when "quotation"
            $("#ct-middle").trigger("zoneFocus")
            if item.id
              @get('controller').transitionToRoute 'quotation.show', store.find('quotation', item.id)
          # Event
          when "event"
            $("#ct-middle").trigger("zoneFocus")
            if item.id
              @get('controller').transitionToRoute 'vosaeEvent.show', store.find('vosaeEvent', item.id)
          # CreditNote
          when "creditnote"
            $("#ct-middle").trigger("zoneFocus")
            if item.id
              @get('controller').transitionToRoute 'creditNote.show', store.find('creditNote', item.id)
          # DownPaymentInvoice
          when "downpaymentinvoice"
            $("#ct-middle").trigger("zoneFocus")
            if item.id
              @get('controller').transitionToRoute 'downPaymentInvoice.show', store.find('downPaymentInvoice', item.id)

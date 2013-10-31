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
      
      if item
        switch item.resource_type
          # Contact
          when "contact"
            $("#ct-middle").trigger("zoneFocus")
            if item.id
              @get('controller').transitionToRoute 'contact.show', Vosae.Contact.find(item.id)
          # Organization
          when "organization"
            $("#ct-middle").trigger("zoneFocus")
            if item.id
              @get('controller').transitionToRoute 'organization.show', Vosae.Organization.find(item.id)
          # Invoice
          when "invoice"
            $("#ct-middle").trigger("zoneFocus")
            if item.id
              @get('controller').transitionToRoute 'invoice.show', Vosae.Invoice.find(item.id)
          # Quotation
          when "quotation"
            $("#ct-middle").trigger("zoneFocus")
            if item.id
              @get('controller').transitionToRoute 'quotation.show', Vosae.Quotation.find(item.id)
          # Event
          when "event"
            $("#ct-middle").trigger("zoneFocus")
            if item.id
              @get('controller').transitionToRoute 'vosaeEvent.show', Vosae.VosaeEvent.find(item.id)
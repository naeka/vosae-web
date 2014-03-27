Vosae.InvoiceBaseEditView = Em.View.extend
  attachmentUpload: Em.Object.extend
    progress: 0
    progressAttr: (->
      "width: " + @get('progress') + "%"
    ).property('progress')

  actions:
    openFileUploadBrowser: ->
      @.$('input.fileupload').trigger('click')


  # Initialize file upload zones
  initAttachmentsUpload: (->
    dropZone = @.$('.invoice-attachments td.fileupload .inner')
    adapter = @get('controller.store').adapterFor("file")

    @.$('input.fileupload').fileupload
      url: adapter.buildURL("file")
      dataType: 'json'
      formData:
        ttl: 60*24  # 1 day
      dropZone: dropZone
      pasteZone: dropZone
      paramName: 'uploaded_file'

      start: (e) =>
        @get('controller.content').set 'isUploading', true

      processdone: (e, data) =>
        attachmentUploadId = data.files[data.index].emberId = ++Em.uuid
        attachmentUpload = @get('attachmentUpload').create
          id: attachmentUploadId
          name: data.files[data.index].name
        @get('controller.attachmentUploads').addObject attachmentUpload

      getFilesFromResponse: (data) =>
        attachmentUploadId = data.files[0].emberId
        attachmentUpload = @get('controller.attachmentUploads').findProperty 'id', attachmentUploadId

        @get('controller.store').find("file", data.result['id']).then (file) =>
          @get('controller.content.attachments').addObject file
          @get('controller.content').set 'isUploading', false
          @get('controller.attachmentUploads').removeObject attachmentUpload

      stop: (e) =>
        @get('controller.content').set 'isUploading', false

      error: =>
        @get('controller.content').set 'isUploading', false        
      
      progress: (e, data) =>
        progress = parseInt(data.loaded / data.total * 100, 10)
        attachmentUploadId = data.files['0'].emberId
        attachmentUpload = @get('controller.attachmentUploads').findProperty('id', attachmentUploadId)
        attachmentUpload.set 'progress', progress
  ).on "didInsertElement"

  # ==============================
  # = InvoiceBase Sender Address =
  # ==============================
  senderAddressBlockView: Vosae.InvoiceBaseEditSenderAddressBlock.extend
    init: ->
      @_super()
      @set 'content', @get('controller.currentRevision.senderAddress')

  # ============================
  # = InvoiceBase Organization =
  # ============================
  organizationSearchField: Vosae.OrganizationSearchSelect.extend
    currentAddress: null
    
    init: ->
      @_super()
      @classNames.addObject @get('targetObject.relatedColor')

    ajax: ->
      dict = 
        url: @get("targetObject.store").adapterFor('application').buildURL('search')
        type: 'GET',
        quietMillis: 100,
        data: (term, page) =>
          query = "q=#{term}"
          resourceType = @get('resourceType')
          if Em.isArray resourceType
            resourceType.forEach (type) ->
              query += "&types=#{type}"
          else
            query += "&types=#{resourceType}"
          query

        results: (data, page) =>
          contact = @get('targetObject.currentRevision.contact')
          filteredData = data["objects"].filter (result) ->
            result if (!contact or result.id is contact.get('organization.id'))
          return results: filteredData
    
    onRemove: (event) ->
      @set "targetObject.currentRevision.organization", null

    onSelect: (event) ->
      @get("targetObject.store").find('organization', event.object.id).then (organization) =>
        @updateBillingAddressBlockView organization

    didInsertElement: ->
      @_super()

      if @get("targetObject.currentRevision.organization")
        @get("targetObject.currentRevision.organization").then (organization) =>
          @.$().select2 'data',
            id: organization.get 'id'
            corporate_name: organization.get 'corporateName'
          @.$().select2 'val', organization.get('id')
          @addAddressesToChoiceList organization.get("corporateName"), organization.get("addresses")

    updateBillingAddressBlockView: (organization) ->
      # Set new organization has organization of the invoiceBase
      @get('targetObject.currentRevision').set "organization", organization
      @get("parentView.billingAddressBlock").removeFromAddressList "organization" # Remove old organization addresses

      organization.get("addresses").then (newAddresses) =>
        # If new organization has addresses
        if newAddresses and newAddresses.get('length') > 0
          billingAddress = @addAddressesToChoiceList organization.get('corporateName'), newAddresses
          newAddress = (if billingAddress then billingAddress else newAddresses.objectAt(0))
          @get("parentView.billingAddressBlock").setAddress newAddress
          @get("targetObject.currentRevision.billingAddress").dumpDataFrom newAddress
          @get("targetObject.currentRevision.deliveryAddress").dumpDataFrom newAddress

    # Set addresses has new list of choice
    addAddressesToChoiceList: (corporateName, addresses) ->
      addresses.forEach (address) =>
        obj = Em.Object.create
          string: "#{address.get('streetAddress')} (#{corporateName} - #{address.get('type')})"
          parent: "organization"
          streetAddress: address.get "streetAddress"
          extendedAddress: address.get "extendedAddress"
          postofficeBox: address.get "postofficeBox"
          postalCode: address.get "postalCode"
          city: address.get "city"
          state: address.get "state"
          country: address.get "country"
        
        @get("parentView.billingAddressBlock").addToAddressList obj
        
        if address.get("type") is "BILLING"
          billingAddress = address

      # return a Billing address if there's one
      if billingAddress? then billingAddress else null

    change: ->
      if Em.isEmpty(@get('value'))
        @get("parentView.billingAddressBlock").removeFromAddressList "organization"

  # =======================
  # = InvoiceBase Contact =
  # =======================
  contactSearchField: Vosae.ContactSearchSelect.extend
    currentAddresses: null
    
    ajax: ->
      dict = 
        url: @get("targetObject.store").adapterFor('application').buildURL('search')
        type: 'GET',
        quietMillis: 100,
        data: (term, page) =>
          query = "q=#{term}"
          resourceType = @get('resourceType')
          if Ember.isArray resourceType
            resourceType.forEach (type) ->
              query += "&types=#{type}"
          else
            query += "&types=#{resourceType}"
          query

        results: (data, page) =>
          organization = @get('targetObject.currentRevision.organization')
          filteredData = data["objects"].filter (result) ->
            result if (!organization or result.organization is organization.get('corporateName'))
          return results: filteredData

    onRemove: (event) ->
      @set "targetObject.currentRevision.contact", null

    onSelect: (event) ->
      @get("targetObject.store").find('contact', event.object.id).then (contact) =>
        @updateBillingAddressBlockView contact
    
    didInsertElement: ->
      @_super()
      if @get("targetObject.currentRevision.contact")
        @get("targetObject.currentRevision.contact").then (contact) =>
          @.$().select2 'data',
            id: contact.get 'id'
            full_name: contact.get 'fullName'
          @.$().select2 'val', contact.get('id')
          @addAddressesToChoiceList(contact.get("fullName"), contact.get("addresses"))

    updateBillingAddressBlockView: (contact) ->
      # Set new contact has contact of the invoiceBase
      @get('targetObject.currentRevision').set "contact", contact
      @get("parentView.billingAddressBlock").removeFromAddressList "contact" # Remove old contact addresses

      contact.get("addresses").then (newAddresses) =>
        # If new contact has addresses
        if newAddresses and newAddresses.get('length') > 0
          billingAddress = @addAddressesToChoiceList contact.get('fullName'), newAddresses
          newAddress = (if billingAddress then billingAddress else newAddresses.objectAt(0))
          @get("parentView.billingAddressBlock").setAddress newAddress
          @get("targetObject.currentRevision.billingAddress").dumpDataFrom newAddress

    # Set addresses has new list of choice
    addAddressesToChoiceList: (fullName, addresses) ->
      addresses.forEach (address) =>
        obj = Em.Object.create
          string: "#{address.get('streetAddress')} (#{fullName} - #{address.get('type')})"
          parent: "contact"
          streetAddress: address.get "streetAddress"
          extendedAddress: address.get "extendedAddress"
          postofficeBox: address.get "postofficeBox"
          postalCode: address.get "postalCode"
          city: address.get "city"
          state: address.get "state"
          country: address.get "country"
        
        @get("parentView.billingAddressBlock").addToAddressList obj
        
        if address.get("type") is "BILLING"
          billingAddress = address

      # return a Billing address if there's one
      if billingAddress? then billingAddress else null

    change: ->
      if Em.isNone(@get('value'))
        @get("parentView.billingAddressBlock").removeFromAddressList "contact"

  # ===============================
  # = InvoiceBase Billing Address =
  # ===============================
  billingAddressBlockView: Vosae.InvoiceBaseEditBillingAddressBlock.extend
    content: null
    addressList: null

    init: ->
      @_super()
      @set "addressList", new Array

    setAddress: (address) ->
      if address
        @get("content").setProperties
          "streetAddress": address.get "streetAddress"
          "extendedAddress": address.get "extendedAddress"
          "postofficeBox": address.get "postofficeBox"
          "postalCode": address.get "postalCode"
          "city": address.get "city"
          "state": address.get "state"
          "country": address.get "country"

    addToAddressList: (address) ->
      @get("addressList").pushObject address
      @get("addressListItemsView").rerender()

    removeFromAddressList: (type) ->
      i = @get("addressList.length") - 1
      while i >= 0
        if @get("addressList")[i].get("parent") is type
          @get("addressList")[i].destroy()
          @get("addressList").splice i, 1
        i--
      @get("addressListItemsView").rerender()

    textField: Ember.TextField.extend
      didInsertElement: ->
        @$().attr "data-toggle", @get("data-toggle") if @get("data-toggle") isnt `undefined`

    addressListItemsView: Ember.View.extend
      content: []
      tagName: "ul"
      classNames: ["dropdown-menu"]
      classNameBindings: ["isEmpty:isEmpty"]
      isEmpty: true
      
      checkIfEmpty: (->
        if @get('content.length') then @set('isEmpty', 0) else @set('isEmpty', 1)
      ).observes('content.length')

      init: ->
        @_super()
        @set "content", @get("parentView.addressList")

      rerender: ->
        @set "content", @get("parentView.addressList")
        @_super()

      changeAddress: (address) ->
        @get("parentView").setAddress address

  # ========================
  # = InvoiceBase Currency =
  # ========================
  currencyField: Vosae.Select.extend
    currentRevisionBinding: Em.Binding.oneWay 'controller.currentRevision'
    contentBinding: Em.Binding.oneWay 'controller.session.tenantSettings.invoicing.supportedCurrenciesSymbols'
    valueBinding: Em.Binding.oneWay 'controller.currentRevision.currency.symbol'
    colorBinding: Em.Binding.oneWay 'controller.relatedColor'
    containerCssClass: 'currency'

    setRelatedCorlor: (->
      @classNames.addObject @get('controller.relatedColor')
    ).on "init"

    didInsertElement: ->
      @_super()

      # We are in a new invoiceBase record, currency is empty
      if not @get('controller.id')
        defaultCurrency = @get 'controller.session.tenantSettings.invoicing.defaultCurrency'
        @.$().select2 "val", defaultCurrency.get('symbol')
        @get('currentRevision').updateWithCurrency defaultCurrency

    change: ->
      symbol = @get('value')
      if symbol and symbol isnt @get('currentRevision.currency.symbol')
        currency = @get('controller.session.tenantSettings.invoicing.supportedCurrencies').findBy('symbol', symbol)
        @get('currentRevision').updateWithCurrency currency if currency

  # =====================
  # = InvoiceBase Items =
  # =====================
  lineItemQuantityField: Vosae.TextFieldAutoNumeric.extend
    disabledBinding: Em.Binding.oneWay 'currentItem.shouldDisableField'

    focusOut: (evt) ->
      val = @.$().autoNumeric('get') or 0
      @get('currentItem').set "quantity", val 

  lineItemTextArea: Vosae.TextAreaAutoGrow.extend
    disabledBinding: Em.Binding.oneWay 'currentItem.shouldDisableField'


  lineItemUnitPriceField: Vosae.TextFieldAutoNumeric.extend
    disabledBinding: Em.Binding.oneWay 'currentItem.shouldDisableField'

    didInsertElement: ->
      @_super()
      if @get('currentItem.unitPrice') && @get('currentItem.itemId')
        @.$().autoNumeric('set', @get('currentItem.unitPrice'))

    focusOut: (evt) ->
      val = @.$().autoNumeric('get') or 0
      @get('currentItem').set "unitPrice", val 

    itemUnitPriceObserver: (->
      if @.$().autoNumeric('get') isnt @get('currentItem.unitPrice')
        if @get('currentItem.unitPrice')
          @.$().autoNumeric('set', @get('currentItem.unitPrice'))
        else
          @.$().autoNumeric('set', 0)
    ).observes('currentItem.unitPrice')

  taxesSearchField: Vosae.TaxSearchSelect.extend
    disabledBinding: Em.Binding.oneWay 'currentItem.shouldDisableField'

    didInsertElement: ->
      @_super()

      # Check if currentRevision has a contact
      if @get("currentItem.tax")
        @get("currentItem.tax").then (currentTax) =>
          @.$().select2 'data',
            id: currentTax.get 'id'
            display_tax: currentTax.get 'displayTax'
          @.$().select2 'val', currentTax.get('id')
      else
        @get('currentItem').addObserver 'tax', @, =>
          @get("currentItem.tax").then (currentTax) =>
            @.$().select2 'data',
              id: currentTax.get 'id'
              display_tax: currentTax.get 'displayTax'
            @.$().select2 'val', currentTax.get('id')
          @removeObserver('tax')

    onSelect: (event) ->
      @get("targetObject.store").find('tax', event.object.id).then (tax) =>
        @get("currentItem").set "tax", tax

  itemsSearchField: Vosae.ItemSearchSelect.extend    
    didInsertElement: ->
      @_super()

      currentItem = @get("currentItem")
      if currentItem
        @.$().select2 'data',
          id: currentItem.get 'itemId'
          reference: currentItem.get 'reference'
        @.$().select2 'val', currentItem.get('itemId')

    onSelect: (event) ->
      @get("targetObject.store").find('item', event.object.id).then (item) =>
        @addLineWithItem item

    addLineWithItem: (item) ->
      if @get("currentItem") instanceof Vosae.LineItem

        currentCurrency = @get("targetObject.currentRevision.currency")
        # If the currency is different we convert the unit price
        if currentCurrency.get("symbol") isnt item.get("currency.symbol")
          exchangeRate = currentCurrency.exchangeRateFor item.get("currency.symbol")
          unitPrice = (item.get('unitPrice') / exchangeRate).round(2)
        else
          unitPrice = item.get("unitPrice")

        @get("currentItem").setProperties
          "unitPrice": unitPrice
          "reference": item.get('reference')
          "tax": item.get("tax")              
          "description": item.get("description")
          "type": item.get("type")
          "itemId": item.get("id")
          "quantity": 1

Vosae.InvoiceBaseEditView = Em.View.extend
  attachmentUpload: Em.Object.extend
    progress: 0
    displayProgress: (->
      "width: #{@get('progress')}%"
    ).property('progress')

  actions:
    openFileUploadBrowser: ->
      @.$('input.fileupload').trigger('click')

  didInsertElement: ->
    @_super()
    @initAttachmentsUpload()

  initAttachmentsUpload: ->
    # Initialize file upload zones
    _this = @
    dropZone = @.$('.invoice-attachments td.fileupload .inner')

    adapter = @get('controller.store.adapter')
    rootForVosaeFile = adapter.rootForType(Vosae.File)
    url = adapter.buildURL(adapter.pluralize(rootForVosaeFile))

    @.$('input.fileupload').fileupload
      url: url
      dataType: 'json'
      formData:
        ttl: 60*24  # 1 day
      dropZone: dropZone
      pasteZone: dropZone
      paramName: 'uploaded_file'

      start: (e) =>
        _this.get('controller.content').set 'isUploading', true

      processdone: (e, data) =>
        attachmentUploadId = data.files[data.index].emberId = ++Em.uuid
        attachmentUpload = _this.get('attachmentUpload').create
          id: attachmentUploadId
          name: data.files[data.index].name
        _this.get('controller.attachmentUploads').addObject attachmentUpload

      processalways: (e, data) =>
        Em.run.later _this, (->
          attachmentUploadId = data.files[data.index].emberId
          attachmentUpload = _this.get('controller.attachmentUploads').findProperty 'id', attachmentUploadId
          _this.get('controller.attachmentUploads').removeObject attachmentUpload
        ), 2000

      done: (e, data) =>
        store = _this.get('controller.store')
        fileId = store.adapterForType(Vosae.File).get('serializer').deurlify data.result['resource_uri']
        data.result.id = fileId
        store.adapterForType(Vosae.File).load store, Vosae.File, data.result
        file = store.find Vosae.File, fileId
        _this.get('controller.content.attachments').addObject file
        
        if _this.get('controller.content.id')
          _this.get('controller.content').set 'currentState', DS.RootState.loaded.updated.uncommitted
        _this.get('controller.content').set 'isUploading', false

      stop: (e) =>
        _this.get('controller.content').set 'isUploading', false

      error: =>
        _this.get('controller.content').set 'isUploading', false        
      
      progress: (e, data) =>
        progress = parseInt(data.loaded / data.total * 100, 10)
        attachmentUploadId = data.files['0'].emberId
        attachmentUpload = _this.get('controller.attachmentUploads').findProperty('id', attachmentUploadId)
        if attachmentUpload
          attachmentUpload.set 'progress', progress

  # ==============================
  # = InvoiceBase Sender Address =
  # ==============================
  senderAddressBlockView: Vosae.InvoiceBaseEditSenderAddressBlock.extend
    init: ->
      @_super()
      @set 'content', @get('currentRevision.senderAddress')

  # ============================
  # = InvoiceBase Organization =
  # ============================
  organizationSearchField: Vosae.Components.OrganizationSearchField.extend
    currentAddress: null
    
    init: ->
      @_super()
      @classNames.addObject @get('parentView.controller.content.relatedColor')

    ajax: ->
      dict = 
        url: @get('parentView.controller.store.adapter').buildURL('search')
        type: 'GET',
        quietMillis: 100,
        data: (term, page) =>
          query = "q=#{term}"
          resourceType = @get('resourceType')
          if typeIsArray resourceType
            resourceType.forEach (type) ->
              query += "&types=#{type}"
          else
            query += "&types=#{resourceType}"
          query

        results: (data, page) =>
          contact = @get('controller.currentRevision.contact')
          filteredData = []
          data["objects"].forEach (result) ->
            if !contact or result.id is contact.get('organization.id')
              filteredData.push result
          return results: filteredData
    
    onRemove: (event) ->
      @set "currentRevision.organization", null

    onSelect: (event) ->
      organization = Vosae.Organization.find(event.object.id).then (organization) =>
        @updateBillingAddressBlockView organization

    didInsertElement: ->
      @_super()
 
      organization = @get "currentRevision.organization"
      if organization
        Vosae.Organization.find(organization.get('id')).then (organization) =>
          @.$().select2 'data',
            id: organization.get 'id'
            corporate_name: organization.get 'corporateName'
          @.$().select2 'val', organization.get('id')
          @addAddressesToChoiceList organization.get("corporateName"), organization.get("addresses")

    updateBillingAddressBlockView: (organization) ->
      # Set new organization has organization of the invoiceBase
      @get('currentRevision').set "organization", organization
      @get("parentView.billingAddressBlock").removeFromAddressList "organization" # Remove old organization addresses

      newAddresses = organization.get "addresses"

      # If new organization has addresses
      if newAddresses and newAddresses.get('length') > 0
        billingAddress = @addAddressesToChoiceList organization.get('corporateName'), newAddresses
        newAddress = (if billingAddress then billingAddress else newAddresses.objectAt(0))
        @get("parentView.billingAddressBlock").setAddress newAddress
        @get("currentRevision.billingAddress").dumpDataFrom newAddress
        @get("currentRevision.deliveryAddress").dumpDataFrom newAddress

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
  contactSearchField: Vosae.Components.ContactSearchField.extend
    currentAddresses: null
    
    ajax: ->
      dict = 
        url: @get('parentView.controller.store.adapter').buildURL('search')
        type: 'GET',
        quietMillis: 100,
        data: (term, page) =>
          query = "q=#{term}"
          resourceType = @get('resourceType')
          if typeIsArray resourceType
            resourceType.forEach (type) ->
              query += "&types=#{type}"
          else
            query += "&types=#{resourceType}"
          query

        results: (data, page) =>
          organization = @get('parentView.controller.currentRevision.organization')
          filteredData = []
          data["objects"].forEach (result) ->
            if !organization or result.organization is organization.get('corporateNname')
              filteredData.push result
          return results: filteredData

    onRemove: (event) ->
      @set "currentRevision.contact", null

    onSelect: (event) ->
      contact = Vosae.Contact.find(event.object.id).then (contact) =>
        @updateBillingAddressBlockView contact
    
    didInsertElement: ->
      @_super()

      contact = @get("currentRevision.contact")

      # Check if currentRevision has a contact
      if contact
        if contact.get('isLoaded')
          @.$().select2 'data',
            id: contact.get 'id'
            full_name: contact.get 'fullName'
          @.$().select2 'val', contact.get('id')
          @addAddressesToChoiceList(contact.get("fullName"), contact.get("addresses"))
        else
          contact.one "didLoad", @, ->
            @.$().select2 'data',
              id: contact.get 'id'
              full_name: contact.get 'fullName'
            @.$().select2 'val', contact.get('id')
            @addAddressesToChoiceList(contact.get("fullName"), contact.get("addresses"))


    updateBillingAddressBlockView: (contact) ->
      # Set new contact has contact of the invoiceBase
      @get('currentRevision').set "contact", contact
      @get("parentView.billingAddressBlock").removeFromAddressList "contact" # Remove old contact addresses

      newAddresses = contact.get "addresses"

      # If new contact has addresses
      if newAddresses and newAddresses.get('length') > 0
        billingAddress = @addAddressesToChoiceList contact.get('fullName'), newAddresses
        newAddress = (if billingAddress then billingAddress else newAddresses.objectAt(0))
        @get("parentView.billingAddressBlock").setAddress newAddress
        @get("currentRevision.billingAddress").dumpDataFrom newAddress
        @get("currentRevision.deliveryAddress").dumpDataFrom newAddress

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
  currencyField: Vosae.Components.Select.extend
    currentRevisionBinding: Em.Binding.oneWay 'parentView.controller.content.currentRevision'
    contentBinding: Em.Binding.oneWay 'parentView.controller.session.tenantSettings.invoicing.supportedCurrencies'
    valueBinding: Em.Binding.oneWay 'parentView.controller.content.currentRevision.currency.symbol'
    colorBinding: Em.Binding.oneWay 'parentView.controller.content.relatedColor'
    optionLabelPath: 'content.displaySignWithSymbol'
    optionValuePath: 'content.symbol'
    containerCssClass: 'currency'

    init: ->
      @_super()
      @classNames.addObject @get('parentView.controller.content.relatedColor')

    didInsertElement: ->
      @_super()

      # We are in a new invoiceBase record, currency is empty
      unless @get('parentView.controller.content.id')
        defaultCurrency = @get 'parentView.controller.session.tenantSettings.invoicing.defaultCurrency'

        # Currency may has been updated (especially rates) so
        # we fetch the currency on the server by security
        refreshedCurrency = Vosae.Currency.find
          symbol: defaultCurrency.get 'symbol'
          limit: 1
        .then (refreshedCurrency) =>
          currency = refreshedCurrency.get 'firstObject'
          @get('currentRevision').updateWithCurrency currency

    change: ->
      if @get('value') and @get('value') isnt @get('currentRevision.currency.symbol')
        
        # Currency may has been updated (especially rates) so
        # we fetch the currency on the server by security
        refreshedCurrency = Vosae.Currency.find
          symbol: @get('value')
          limit: 1
        .then (refreshedCurrency) =>
          currency = refreshedCurrency.get 'firstObject'
          @get('currentRevision').updateWithCurrency currency

  # =====================
  # = InvoiceBase Items =
  # =====================
  lineItemQuantityField: Vosae.AutoNumericField.extend
    disabledBinding: Em.Binding.oneWay 'currentItem.shouldDisableField'

    focusOut: (evt) ->
      val = @.$().autoNumeric('get') or 0
      @get('currentItem').set "quantity", val 

  lineItemTextArea: Vosae.TextAreaAutoSize.extend
    disabledBinding: Em.Binding.oneWay 'currentItem.shouldDisableField'


  lineItemUnitPriceField: Vosae.AutoNumericField.extend
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

  taxesSearchField: Vosae.Components.TaxSearchField.extend
    disabledBinding: Em.Binding.oneWay 'currentItem.shouldDisableField'

    didInsertElement: ->
      @_super()
      currentTax = @get("currentItem.tax")

      # Check if currentRevision has a contact
      if currentTax
        if currentTax.get('isLoaded')
          @.$().select2 'data',
            id: currentTax.get 'id'
            display_tax: currentTax.get 'displayTax'
          @.$().select2 'val', currentTax.get('id')
        else
          currentTax.one "didLoad", @, ->
            @.$().select2 'data',
              id: currentTax.get 'id'
              display_tax: currentTax.get 'displayTax'
            @.$().select2 'val', currentTax.get('id')
      else
        @get('currentItem').addObserver 'tax', @, ->
          currentTax = @get 'currentItem.tax'
          if currentTax and currentTax.get('isLoaded')
            @.$().select2 'data',
              id: currentTax.get 'id'
              display_tax: currentTax.get 'displayTax'
            @.$().select2 'val', currentTax.get('id')
            @removeObserver('tax')

    onSelect: (event) ->      
      @get("currentItem").set "tax", Vosae.Tax.find event.object.id

  itemsSearchField: Vosae.Components.ItemSearchField.extend    
    didInsertElement: ->
      @_super()
 
      currentItem = @get("currentItem")

      # Check if currentRevision has a contact
      if currentItem
        if currentItem.get('isLoaded')
          @.$().select2 'data',
            id: currentItem.get 'itemId'
            reference: currentItem.get 'ref'
          @.$().select2 'val', currentItem.get('itemId')
        else
          currentItem.one "didLoad", @, ->
            @.$().select2 'data',
              id: currentItem.get 'itemId'
              reference: currentItem.get 'ref'
            @.$().select2 'val', currentItem.get('id')

    onSelect: (event) ->
      item = Vosae.Item.find(event.object.id)

      # Wait for item to be fully loaded by ember
      if item.get("isLoaded")
        @addLineWithItem item
      else
        item.one "didLoad", @, ->
          @addLineWithItem item

    addLineWithItem: (item) ->
      if Em.typeOf(@get("currentItem")) is "instance"

        currentCurrency = @get("parentView.controller.currentRevision.currency")

        # If the currency is different we convert the unit price
        if currentCurrency.get("symbol") isnt item.get("currency.symbol")
          exchangeRate = currentCurrency.exchangeRateFor item.get("currency.symbol")
          unitPrice = (item.get('unitPrice') / exchangeRate.get('rate')).round(2)
        else
          unitPrice = item.get("unitPrice")

        @get("currentItem").set "unitPrice", unitPrice
        @get("currentItem").set "ref", item.get('ref')
        @get("currentItem").set "tax", item.get("tax")              
        @get("currentItem").set "description", item.get("description")
        @get("currentItem").set "type", item.get("type")
        @get("currentItem").set "itemId", item.get("id")
        @get("currentItem").set "quantity", 1

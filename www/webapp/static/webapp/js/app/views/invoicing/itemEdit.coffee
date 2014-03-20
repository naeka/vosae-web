Vosae.ItemEditView = Em.View.extend
  templateName: "item/edit"
  classNames: ["page-edit-item", "page-show-item"]

  # Field for item reference
  referenceField: Em.TextField.extend
    keyUp: (evt) ->
      text = @get('value').replace(/[^a-zA-Z0-9-_]/g, "")
      @set('value', text)

  # Field for item unit price`
  unitPriceField: Vosae.TextFieldAutoNumeric.extend
    didInsertElement: ->
      @_super()
      # Set initial value
      if @get('item.unitPrice')
        @.$().autoNumeric('set', @get('item.unitPrice'))

    focusOut: (evt) ->
      @get('item').set "unitPrice", @.$().autoNumeric('get')

    itemUnitPriceObserver: (->
      if @.$().autoNumeric('get') isnt @get('item.unitPrice')
        if @get('item.unitPrice')
          @.$().autoNumeric('set', @get('item.unitPrice'))
        else
          @.$().autoNumeric('set', 0)
    ).observes('item.unitPrice')


Vosae.ItemEditSettingsView = Em.View.extend Vosae.HelpTourMixin,
  classNames: ["app-invoice", "page-edit-item-settings", "page-settings"]

  initHelpTour: ->
    helpTour = @_super()

    helpTour.addStep
      element: ".page-edit-item .helptour-itemtype"
      title: gettext "Item type (required field)"
      content: gettext "This button lets you specify whether your item is a product or a service."
      placement: "left"

    helpTour.addStep
      element: ".page-edit-item .product"
      title: gettext "Product or service name (required field)"
      content: gettext "The name of your item. Can be on multiple lines.<br>Usually, the first line is a simple name, for example: <i>Black chair</i> or <i>Website</i> while next lines are description, like: <i>A beautiful handmade chair</i>."
      placement: "right"

    helpTour.addStep
      element: ".page-edit-item .reference"
      title: gettext "Item reference (required field)"
      content: gettext "The reference is an internal unique identifier (for accounting purpose). It won't be visible for your customers on generated documents. Usually in capitals, like: <i>CHAIR-BLK-04</i>."
      placement: "right"

    helpTour.addStep
      element: ".page-edit-item .helptour-itemprice"
      title: gettext "Item price (required field)"
      content: gettext "Here you can define the price of your item and indicate any applicable tax as well as the currency. You can add or remove taxes and supported currencies in your <strong>Settings</strong>."
      placement: "right"

    helpTour.addStep
      element: ".page-edit-item .actions-form .helptour-itemsave"
      title: gettext "Create the item"
      content: gettext "Finally, <strong>Save</strong> (or <strong>Cancel</strong>) your item to add it to <i>Vosae</i>."
      placement: "top"

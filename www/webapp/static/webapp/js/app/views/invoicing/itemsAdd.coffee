Vosae.ItemsAddView = Em.View.extend
  templateName: "item/edit"
  classNames: ["page-edit-item", "page-show-item"]

  didInsertElement: ->
    @_super()
    # Focus on first input text
    @.$().find('.ember-text-field').first().focus()

  referenceField: Em.TextField.extend
    keyUp: (evt) ->
      text = @get('value').replace(/[^a-zA-Z0-9-_]/g, "")
      @set('value', text)

  unitPriceField: Vosae.TextFieldAutoNumeric.extend(
    focusOut: (evt) ->
      @get('item').set "unitPrice", @.$().autoNumeric('get')     

    itemUnitPriceObserver: (->
      if @.$().autoNumeric('get') isnt @get('item.unitPrice')
        if @get('item.unitPrice')
          @.$().autoNumeric('set', @get('item.unitPrice'))
        else
          @.$().autoNumeric('set', 0)
    ).observes('item.unitPrice')
  )
Vosae.Item = DS.Model.extend
  ref: DS.attr('string')
  description: DS.attr('string')
  unitPrice: DS.attr('number')
  type: DS.attr('string')
  currency: DS.belongsTo('Vosae.Currency')
  tax: DS.belongsTo('Vosae.Tax')

  displayUnitPrice: (->
    # Returns the unit price formated with a precision of 2
    if @get("unitPrice")
      return accounting.formatNumber(@get("unitPrice"), {precision: 2, decimal: "."})
    return
  ).property("unitPrice")

  displayType: (->
    # Returns the item type
    if @get('type') is "PRODUCT"
      return gettext('Product') 
    gettext('Service')
  ).property('type')

  isEmpty: ->
    # Return true if item is empty
    if @get 'ref'
      return false
    if @get 'description'
      return false
    if @get 'unitPrice'
      return false
    if @get 'type'
      return false
    if @get 'currency'
      return false
    if @get 'tax'
      return false
    return true

  getErrors: (type) ->
    errors = []

    unless @get("ref")
      errors.addObject gettext("Item reference must not be blank")
    unless @get("description")
      errors.addObject gettext("Item description must not be blank")
    unless @get("unitPrice")
      errors.addObject gettext("Item unit price must not be blank")
    unless @get("tax")
      errors.addObject gettext("Item tax must not be blank")
    unless @get("currency")
      errors.addObject gettext("Item currency must not be blank")
    return errors

  didCreate: ->
    message = gettext 'Your item has been successfully created'
    Vosae.SuccessPopupComponent.open
      message: message

  didUpdate: ->
    message = gettext 'Your item has been successfully updated'
    Vosae.SuccessPopupComponent.open
      message: message

  didDelete: ->
    message = gettext 'Your item has been successfully deleted'
    Vosae.SuccessPopupComponent.open
      message: message

Vosae.Adapter.map "Vosae.Item",
  ref:
    key: "reference"
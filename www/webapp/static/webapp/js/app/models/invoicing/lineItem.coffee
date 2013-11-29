Vosae.LineItem = DS.Model.extend
  ref: DS.attr('string')
  description: DS.attr('string')
  itemId: DS.attr('string')
  quantity: DS.attr('number')
  unitPrice: DS.attr('number')
  tax: DS.belongsTo('Vosae.Tax')
  
  shouldDisableField: (->
    # Returns true if current line item hasn't reference
    if @get('ref')
      return false
    true
  ).property('ref')

  total: (->
    if @get("quantity") and @get("unitPrice")
      return (@get("quantity") * @get("unitPrice"))
    0
  ).property("quantity", "unitPrice")

  totalVAT: (->
    if @get("quantity") and @get("unitPrice") and @get("tax.isLoaded")
      total = (@get("quantity") * @get("unitPrice"))
      return total + (total * @get("tax.rate"))
    0
  ).property("quantity", "unitPrice", "tax.isLoaded")

  displayTotal: (->
    if @get('total') 
      return accounting.formatMoney @get('total')
    accounting.formatMoney 0
  ).property("total")

  displayTotalVAT: (->
    if @get('totalVAT') 
      return accounting.formatMoney @get('totalVAT')
    accounting.formatMoney 0
  ).property("totalVAT")

  displayUnitPrice: (->
    if @get("unitPrice")
      return accounting.formatMoney @get("unitPrice")
    accounting.formatMoney 0
  ).property("unitPrice")

  displayQuantity: (->
    if @get("quantity")
      return accounting.formatMoney @get("quantity")
    accounting.formatMoney 0
  ).property("quantity")

  didLoad: ->
    # hack (bug on tax isLoaded)
    # This should probably be removed
    if @get('tax') and not @get('tax.isLoaded')
      @get('tax').one 'isLoaded', @, ->
        Ember.run.next @, ->
          @propertyDidChange('tax')

  VAT: ->
    if @get("quantity") and @get("unitPrice") and @get("tax.isLoaded")
      total = (@get("quantity") * @get("unitPrice")) * @get("tax.rate")
      return (
        total: total
        tax: @get("tax")
      )
    null

  isEmpty: ->
    # Return true if item is empty
    if @get 'ref'
      return false
    if @get 'description'
      return false
    if @get 'itemId'
      return false
    if @get 'quantity'
      return false
    if @get 'unitPrice'
      return false
    if @get 'tax'
      return false
    return true

Vosae.Adapter.map "Vosae.LineItem",
  ref:
    key: "reference"
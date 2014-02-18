Vosae.InvoiceBaseEditBillingAddressBlock = Em.View.extend
  templateName: 'invoicebase-edit-billing-address-block'
  classNames: 'invoicebase-edit-billing-address-block'

Vosae.InvoiceBaseEditSenderAddressBlock = Em.View.extend
  templateName: 'invoicebase-edit-sender-address-block'
  classNames: 'invoicebase-edit-sender-address-block'
  content: null



##
# Custom typeahead field for models
#
Vosae.TypeaheadField = Em.TextField.extend
  minLength: 2
  items: 5
  property: 'name'

  didInsertElement: ->
    self = @

    @$().vosaetypeahead(
      minLength: self.get("minLength")
      items: self.get("items")
      property: self.get("property")

      source: (typeahead, query) ->
        return self.source(typeahead, query)

      onselect: (obj) ->
        return self.onSelect(obj)
    )

  onSelect: (obj) ->
    throw new Error("Typeahead field error: You need to overide the 'onSelect' method.")

  source: (typeahead, query) ->
    throw new Error("Typeahead field error: You need to overide the 'source' method.")
 
  willDestroyElement: ->
    @.$().vosaetypeahead 'destroy'
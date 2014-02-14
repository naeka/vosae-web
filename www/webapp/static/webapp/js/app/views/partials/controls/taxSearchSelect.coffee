###
  This autocomplete search create an ajax request on the API search 
  end point for resource <Vosae.Tax>.
  Example : /api/search/?q=tva&types=tax

  @class TaxSearchSelect
  @extends Vosae.ResourceSearchSelect
  @namespace Vosae
  @module Vosae
###

Vosae.TaxSearchSelect = Vosae.ResourceSearchSelect.extend
  resourceType: 'tax'

  ajax: ->
    object = 
      url: Vosae.lookup('store:main').get('adapter').buildURL('search')
      type: 'GET',
      quietMillis: 100,
      data: (term, page) =>
        "q=#{term}"
      results: (data, page) =>
        objects = $.map Vosae.Tax.all().toArray(), (obj) ->
          id: obj.get('id')
          display_tax: obj.get('displayTax')
        results: objects

  formatResult: (tax) ->
    "<div title='#{tax.display_tax}'>#{tax.display_tax}</div>"

  formatSelection: (tax) ->
    tax.display_tax

  formatSelectionTooBig: ->
    gettext 'Only one tax can be selected'
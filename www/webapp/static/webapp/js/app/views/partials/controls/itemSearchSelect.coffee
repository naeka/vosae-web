###
  This autocomplete select create an ajax request on the API search 
  end point for resource <Vosae.Item>.
  Example : /api/search/?q=product&types=item

  @class ItemSearchSelect
  @extends Vosae.ResourceSearchSelect
  @namespace Vosae
  @module Vosae
###

Vosae.ItemSearchSelect = Vosae.ResourceSearchSelect.extend
  resourceType: 'item'

  formatResult: (item) ->
    description = item.description.split('\n')[0]
    "<div title='#{item.description}'>[#{item.reference}] #{description}</div>"

  formatSelection: (item) ->
    item.reference

  formatSelectionTooBig: ->
    gettext 'Only one item can be selected'

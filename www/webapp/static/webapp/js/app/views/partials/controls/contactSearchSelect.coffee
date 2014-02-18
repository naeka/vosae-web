###
  This autocomplete select create an ajax request on the API search 
  end point for resource <Vosae.Contact>.
  Example : /api/search/?q=tom&types=contact

  @class ContactSearchSelect
  @extends Vosae.ResourceSearchSelect
  @namespace Vosae
  @module Vosae
###

Vosae.ContactSearchSelect = Vosae.ResourceSearchSelect.extend
  resourceType: 'contact'

  formatResult: (contact) ->
    "<div title='#{contact.full_name}'>#{contact.full_name}</div>"

  formatSelection: (contact) ->
    contact.full_name

  formatSelectionTooBig: ->
    gettext 'Only one contact can be selected'
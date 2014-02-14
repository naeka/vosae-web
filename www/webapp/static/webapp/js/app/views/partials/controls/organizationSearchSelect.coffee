###
  This autocomplete select create an ajax request on the API search 
  end point for resource <Vosae.Organization>.
  Example : /api/search/?q=naeka&types=organization

  @class OrganizationSearchSelect
  @extends Vosae.ResourceSearchSelect
  @namespace Vosae
  @module Vosae
###

Vosae.OrganizationSearchSelect = Vosae.ResourceSearchSelect.extend
  resourceType: 'organization'

  formatResult: (organization) ->
    "<div title='#{organization.corporate_name}'>#{organization.corporate_name}</div>"

  formatSelection: (organization) ->
    organization.corporate_name

  formatSelectionTooBig: ->
    gettext 'Only one organization can be selected'
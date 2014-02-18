###
  This autocomplete select create an ajax request on the API search 
  end point for resource <Vosae.User>.
  Example : /api/search/?q=tom&types=user

  @class UserSearchSelect
  @extends Vosae.ResourceSearchSelect
  @namespace Vosae
  @module Vosae
###

Vosae.UserSearchSelect = Vosae.ResourceSearchSelect.extend
  resourceType: 'user'
  containerCssClass: 'calendarList-acl-entity'

  formatResult: (obj) ->
    "<div title='#{obj.full_name}'>#{obj.full_name}</div>"

  formatSelection: (obj) ->
    obj.full_name

  formatSelectionTooBig: ->
    gettext 'Only one user or group can be selected'

  formatNoMatches: (term) ->
    "<span>" + gettext("No results for '#{term}'") + "</span>"
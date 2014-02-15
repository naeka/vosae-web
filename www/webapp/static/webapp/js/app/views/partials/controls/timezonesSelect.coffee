###
  This select display all timezones.

  @class TimezonesSelect
  @extends Vosae.Select
  @namespace Vosae
  @module Vosae
###

Vosae.TimezonesSelect = Vosae.Select.extend
  hideSearchField: false
  containerCssClass: 'timezones'
  content: Vosae.Timezones
  optionLabelPath: 'content.displayName'
  optionValuePath: 'content.value'
  prompt: gettext 'Timezone'

  # Format each colors entry
  formatResult: (result, container, query, escapeMarkup, select2) ->
    result.text

  # Format selected color
  formatSelection: (data, container) ->
    data.text
###
  This component display a select element that contains
  all timezones.

  @class TimezonesField
  @namespace Vosae
  @module Components
###

Vosae.Components.TimezonesField = Vosae.Components.Select.extend
  hideSearchField: false
  containerCssClass: 'timezones'
  content: Vosae.timezones
  optionLabelPath: 'content.displayName'
  optionValuePath: 'content.value'
  prompt: gettext 'Timezone'

  # Format each colors entry
  formatResult: (result, container, query, escapeMarkup, select2) ->
    result.text

  # Format selected color
  formatSelection: (data, container) ->
    data.text
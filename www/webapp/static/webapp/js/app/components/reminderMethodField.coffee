###
  This component display a select that contains a list 
  of reminder like 'email', or 'notification'

  @class ReminderMethodField
  @namespace Vosae
  @module Components
###

Vosae.Components.ReminderMethodField = Vosae.Components.Select.extend
  containerCssClass: 'green reminder-method'
  content: Vosae.reminderEntries
  optionLabelPath: 'content.displayName'
  optionValuePath: 'content.value'

  # Format each colors entry
  formatResult: (result, container, query, escapeMarkup, select2) ->
    result.text

  # Format selected color
  formatSelection: (data, container) ->
    data.text
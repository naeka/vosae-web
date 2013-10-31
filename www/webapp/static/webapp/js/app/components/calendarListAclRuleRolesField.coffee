Vosae.Components.CalendarListAclRuleRolesField = Vosae.Components.Select.extend
  containerCssClass: 'calendarList-acl-role'
  content: Vosae.calendarAclRuleRoles
  optionLabelPath: 'content.displayName'
  optionValuePath: 'content.value'

  # Format each colors entry
  formatResult: (result, container, query, escapeMarkup, select2) ->
    result.text

  # Format selected color
  formatSelection: (data, container) ->
    data.text
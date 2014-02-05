Vosae.Components.CalendarListColorField = Vosae.Components.Select.extend
  containerCssClass: 'green'
  dropdownCssClass: 'calendarList-color'
  content: Vosae.calendarListColors
  optionLabelPath: 'content.displayName'
  optionValuePath: 'content.value'
  prompt: gettext 'Color'

  # Format each colors entry
  formatResult: (result, container, query, escapeMarkup, select2) ->
    colorBack = result.id
    colorBord = Color(colorBack).darken(0.3).hexString()
    markup = "<span style='background-color: #{colorBack}; border-color: #{colorBord};'></span> #{result.text}"  

  # Format selected color
  formatSelection: (data, container) ->
    data.text

  didInsertElement: ->
    @_super()
    
    color = @get 'value'
    if color
      @$().parent().find('.select2-choice').css 'background', color

  change: (ev) ->
    @$().parent().find('.select2-choice').css 'background', ev.val
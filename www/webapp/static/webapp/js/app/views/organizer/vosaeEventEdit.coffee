Vosae.VosaeEventEditView = Em.View.extend
  classNames: ["app-organizer", "page-edit-event"]

  didInsertElement: ->
    @_super()
    # Focus on first input text
    @.$().find('.ember-text-field').first().focus()

  calendarsField: Vosae.Components.Select.extend
    formatResult: (state) ->
      return state.text unless state.id 
      "<span class='calendar-color'></span> #{state.text}"


  startDateField: Vosae.DatePickerField.extend
    didInsertElement: ->
      @_super()
      @$()
        .val(moment(@get('content.dateOrDatetime')).format('L'))
        .datepicker(@datepicker_settings)
        .on 'changeDate', (ev) =>
          @$().autoGrow(0)
          @set 'content.onlyDate', ev.date
        .autoGrow(0)

  startTimeField: Vosae.TimePickerField.extend
    didInsertElement: ->
      @_super()
      @$(':first-child')
        .timepicker(@timepicker_settings)
        .on 'change', (ev) ->
          $(this).autoGrow(0)
        .on 'changeTime.timepicker', (ev) =>
          @set 'content.onlyTime', new Date(0, 0, 0, ev.time.hours, ev.time.minutes)
        .autoGrow(0)

  endDateField: Vosae.DatePickerField.extend
    didInsertElement: ->
      @_super()
      @$()
        .val(moment(@get('content.dateOrDatetime')).format('L'))
        .datepicker(@datepicker_settings)
        .on 'changeDate', (ev) =>
          @$().autoGrow(0)
          @set 'content.onlyDate', ev.date
        .autoGrow(0)

  endTimeField: Vosae.TimePickerField.extend
    didInsertElement: ->
      @_super()
      @$(':first-child')
        .timepicker(@timepicker_settings)
        .on 'change', (ev) ->
          $(this).autoGrow(0)
        .on 'changeTime.timepicker', (ev) =>
          @set 'content.onlyTime', new Date(0, 0, 0, ev.time.hours, ev.time.minutes)
        .autoGrow(0)

  attendeeView: Em.View.extend
    classNames: ["attendee-card"]
    tagName: "li"
    templateName: "vosaeEvent/edit/attendee"

    emailField: Vosae.TypeaheadField.extend(Vosae.AutoGrowMixin,
      minLength: 1
      source: (typeahead, query) ->
        self = @
        $.map Vosae.User.all().toArray(), (user) ->
          if user.get('email') in self.get('parentView.parentView.controller.attendees').getEach('email')
            return null
          id: user.get 'id'
          name: user.get 'email'
      onSelect: (obj) ->
        user = Vosae.User.find(obj.id)
        isOrganizer = if user is @get('controller.content.organizer') then true else false
        @get('parentView.content').setProperties
          displayName: user.get('fullName')
          photoUri: user.get('photoUri')
          vosaeUser: user
          organizer: isOrganizer
        Em.run.next(@, -> @get('parentView').$('input').change())
    )

    displayNameField: Vosae.TypeaheadField.extend(Vosae.AutoGrowMixin,
      minLength: 1
      source: (typeahead, query) ->
        self = @
        $.map Vosae.User.all().toArray(), (user) ->
          if user.get('email') in self.get('parentView.parentView.controller.attendees').getEach('email')
            return null
          id: user.get 'id'
          name: user.get 'fullName'
      onSelect: (obj) ->
        user = Vosae.User.find(obj.id)
        @get('parentView.content').setProperties
          email: user.get('email')
          photoUri: user.get('photoUri')
          vosaeUser: user
        Em.run.next(@, -> @get('parentView').$('input').change())
    )

    responseStatutesSelect: Vosae.StyledGreenSelect.extend
      select2Settings:
        minimumResultsForSearch: 6
        formatSelection: (object, container)->
          container.parent()
            .removeClass('NEEDS-ACTION DECLINED TENTATIVE ACCEPTED')
            .addClass(object.id)
            .prop('title', object.text)
          null

    didInsertElement: ->
      @_super()
      @$('.email input').focus() if @get('controller.isDirty')
      @$('.attendee-infos input').autoGrow(0)

  reminderView: Em.View.extend
    classNames: ["reminder-entry"]
    tagName: "li"
    templateName: "vosaeEvent/edit/reminder"

    didInsertElement: ->
      @_super()
      @$('input').focus() if @get('controller.isDirty')
      @$('input').autoGrow(0)


Vosae.VosaeEventEditSettingsView = Em.View.extend Vosae.HelpTour,
  classNames: ["page-edit-event-settings", "page-settings"]

  initHelpTour: ->
    helpTour = @_super()

    helpTour.addStep
      element: ".app-organizer .date-ad"
      title: gettext "Date"
      content: gettext "The date of an <strong>Event</strong> can be edited very precisely."
      placement: "right"

    helpTour.addStep
      element: ".app-organizer .calendar"
      title: gettext "Calendar"
      content: gettext "You can change which calendar the <strong>Event</strong> belongs to. If you have a lot of calendars just start typing the name and <i>Vosae</i> will pull it up for you."
      placement: "left"

    helpTour.addStep
      element: ".app-organizer .addAttendee"
      title: gettext "Calendar"
      content: gettext "Add one or more attendees to the <strong>Event</strong>. If he or she is already in your <strong>Contacts</strong>, <i>Vosae</i> will find him/her instantly."
      placement: "top"

    helpTour.addStep
      element: ".app-organizer .helptour-eventinfos"
      title: gettext "Calendar"
      content: gettext "If you want to add more information to the <strong>Event</strong>, you can specify a <i>Location</i>, write a <i>Description</i>, change the <i>Color</i> or add a <i>Reminder</i>."
      placement: "right"

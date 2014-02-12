Vosae.CalendarListsShowView = Em.ContainerView.extend
  childViews: ["fullCalendarView"]
  classNames: ["app-organizer", "page-show-organizer"]
  classNameBindings: ['hasQuickAddEvent'],
  
  hasQuickAddEvent: false

  fullCalendarView: Em.View.extend
    classNames: ["full-calendar"]
    todayButtonText: null
    todayButtonWidth: null

    didInsertElement: ->
      _this = @
      momentLang = moment.langData()

      # This tweak replace the fullcalendar button text by 'Today' on hover
      $(document).on("mouseenter", ".fc-header .fc-button-today:not(.fc-state-disabled) .fc-button-inner", ->
        element = $(@).find(".fc-button-content")
        _this.set 'todayButtonText', $(element).html()
        $(element).css 'width', element.width()
        $(element).html gettext('Today')
      ).on "mouseleave", ".fc-header .fc-button-today:not(.fc-state-disabled) .fc-button-inner", ->
        element = $(@).find(".fc-button-content")
        $(element).html _this.get('todayButtonText')

      fc = @$().fullCalendar
        # initial
        defaultView: if _this.get('controller.lastView') then _this.get('controller.lastView') else 'month'
        year: if _this.get('controller.lastViewStart') then _this.get('controller.lastViewStart').getFullYear() else undefined
        month: if _this.get('controller.lastViewStart') then _this.get('controller.lastViewStart').getMonth() else undefined
        date: if _this.get('controller.lastViewStart') then _this.get('controller.lastViewStart').getDate() else undefined

        # display
        header:
          left: 'prev,today,next'
          right: 'agendaDay,agendaWeek,month'
        currentTimeIndicator: true
        slotMinutes: 60
        
        # editing
        editable: true

        # time formats
        columnFormat:
          week: 'ddd d'
          day: ''
        timeFormat: # for event elements
          '': pgettext 'time format', 'h(:mm)t'
          agenda: pgettext 'time format', 'h:mm{ - h:mm}'
        axisFormat: pgettext 'time format', 'h(:mm)tt'
        
        # locale
        firstDay: get_format 'FIRST_DAY_OF_WEEK'
        monthNames: momentLang._months
        monthNamesShort: momentLang._monthsShort
        dayNames: momentLang._weekdays
        dayNamesShort: momentLang._weekdaysShort
        buttonText:
          prev: ''
          next: ''
          today: gettext 'Today'
          month: gettext 'month'
          week: gettext 'week'
          day: gettext 'day'
        allDayText: gettext 'all-day'
        
        selectable: true

        viewDisplay: (view)->
          switch view.name
            when 'month'
              text = moment(view.start).format 'MMMM YYYY'
            when 'agendaWeek'
              end = moment(view.end).subtract('days', 1)
              text = moment.twix(view.start, end, true).format()
            when 'agendaDay'
              text = moment(view.start).format gettext('dddd, MMMM D YYYY')
          $('.fc-button-today .fc-button-content').text text
          _this.get('controller').set('lastViewStart', view.start)

        viewChanged: (old_name, new_name, view) ->
          _this.get('controller')
            .set('lastView', new_name)
            .set('lastViewStart', view.start)

        eventClick: (calEvent, jsEvent, view) ->
          _this.get('controller').transitionToRoute 'vosaeEvent.show', _this.get('controller.session.tenant'), Vosae.VosaeEvent.find calEvent.id

        select: (startDate, endDate, allDay, jsEvent, view) ->
          calendarLists = Vosae.CalendarList.all()

          # create a new record
          unusedTransaction = _this.get('controller.store').transaction()
          start = unusedTransaction.createRecord Vosae.EventDateTime
          end = unusedTransaction.createRecord Vosae.EventDateTime           
          ev = Vosae.VosaeEvent.createRecord(color: null)
          ev.setProperties
            'calendar': calendarLists.get 'firstObject.calendar'
            'calendarList': calendarLists.get 'firstObject'
            'start': start
            'end': end

          if allDay
            ev.setProperties
              'start.date': startDate
              'end.date': endDate
          else
            ev.setProperties
              'start.datetime': startDate
              'end.datetime': endDate

          # create a quick add event view
          parentView = _this.get 'parentView'
          quickAddView = parentView.createChildView parentView.get('quickAddEventView'),
            controller: _this.get 'controller.controllers.quickAddEvent'
          parentView.pushObject quickAddView
          parentView.get('controller.controllers.quickAddEvent').setProperties
            'content': ev
            'calendarLists': calendarLists
          
          # handling events
          ev.addObserver 'isDeleted', quickAddView, (ev) ->
            quickAddView.destroy()
            ev.removeObserver 'isDeleted'

          ev.one 'didDelete', quickAddView, (ev) ->
            quickAddView.destroy()

          ev.one 'didCreate', quickAddView, (ev) ->
            Em.run.next ->
              fcEvent = ev.getFullCalendarEvent()

              # Once created, we add event to fullCalendar
              unless ev.get 'color'
                $.extend fcEvent,
                  color: ev.get 'calendarList.color'
                  textColor: ev.get 'calendarList.textColor'
              fc.fullCalendar 'renderEvent', fcEvent

              quickAddView.destroy()

      @get('controller.controllers.calendarListsShow').set 'fc', fc
      @get('controller.controllers.calendarListsShowSettings').set 'fcRendered', true

    willDestroyElement: ->
      @get('controller.controllers.calendarListsShow.fc').fullCalendar('destroy')
      @get('controller.controllers.calendarListsShow').set 'fc', null
      @get('controller.controllers.calendarListsShowSettings').set 'fcRendered', false

  quickAddEventView: Em.View.extend
    classNames: ["quick-add-event"]
    layout: Ember.Handlebars.compile("<div class='inner'>{{yield}}</div>")
    templateName: "calendarLists/show/quickAddEvent"

    didInsertElement: ->
      @set('parentView.hasQuickAddEvent', true)
      Em.run.later @, (->
        @$().find('input').first().focus()
      ), 200

    willDestroyElement: ->
      @set('parentView.hasQuickAddEvent', false)

Vosae.CalendarListsShowSettingsView = Em.View.extend Vosae.HelpTour,
  classNames: ["page-settings", "page-show-organizer-settings"]

  initHelpTour: ->
    helpTour = @_super()

    helpTour.addStep
      element: ".page-show-organizer .fc-content"
      title: gettext "Organizer"
      content: gettext "This is the main view of your <strong>Organizer</strong>. <i>Vosae</i> displays all your upcoming events for the current month. You can easily add a new event by clicking on the day or time-slot of your choice. Once created, you can move it to a different slot by dragging and dropping. Simply click on any event to see all the details."
      placement: "top"

    helpTour.addStep
      element: ".page-show-organizer .fc-button-today .fc-button-inner"
      title: gettext "Date"
      content: gettext "You can indicate a period or specific day for your <strong>Organizer</strong> to display by clicking on the arrows. If you want to go to today simply click on the middle button."
      placement: "bottom"
   
    helpTour.addStep
      element: ".page-show-organizer .fc-header-right .fc-button-agendaDay"
      title: gettext "Zoom"
      content: gettext "You can choose the magnification of the display. The more you zoom, the more details you'll see."
      placement: "left"
      

  calendarEntryView: Em.View.extend
    didInsertElement: ->
      @$().css
        "background-color": @get('content.color')
        "color": @get('content.color')

      @$().children().css 'color', @get('content.textColor')

    colorObserver: (->
      background_color = if @get('content.selected') then @get('content.color') else '#ddd'
      textColor = if @get('content.selected') then @get('content.textColor') else '#333'
      @$().css
        "background-color": background_color
        "color": background_color

      @$().children().css 'color', textColor
      @get('controller.controllers.calendarListsShow').get('fc').fullCalendar('rerenderEvents')
    ).observes('content.color', 'content.selected')

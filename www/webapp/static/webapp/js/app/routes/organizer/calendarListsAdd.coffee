Vosae.CalendarListsAddRoute = Ember.Route.extend
  init: ->
    @_super()
    @get('container').register 'controller:calendarLists.add', Vosae.CalendarListEditController

  setupController: (controller, model) ->
    acl = Vosae.CalendarAcl.createRecord()
    calendar = Vosae.VosaeCalendar.createRecord()
    calendarList = Vosae.CalendarList.createRecord()

    acl.get('rules').createRecord
      'principal': @get("session.user")
      'role': 'OWNER'
    calendar.set 'acl', acl
    calendarList.set 'calendar', calendar
    controller.set 'content', calendarList

  renderTemplate: ->
    @_super()
    @render 'calendarList.edit.settings',
      into: 'application'
      outlet: 'outletPageSettings'

Vosae.CalendarListsAddRoute = Ember.Route.extend
  registerController: (->
    @get('container').register 'controller:calendarLists.add', Vosae.CalendarListEditController
  ).on "init"

  model: ->
    Vosae.CalendarList.createRecord()

  setupController: (controller, model) ->
    acl = Vosae.CalendarAcl.createRecord()
    calendar = Vosae.VosaeCalendar.createRecord()
    model.get('reminders').createRecord()
    acl.get('rules').createRecord
      'principal': @get("session.user")
      'role': 'OWNER'
    calendar.set 'acl', acl
    model.set 'calendar', calendar
    controller.set 'content', model

  renderTemplate: ->
    @_super()
    @render 'calendarList.edit.settings',
      into: 'application'
      outlet: 'outletPageSettings'

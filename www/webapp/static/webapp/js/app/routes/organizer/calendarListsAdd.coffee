Vosae.CalendarListsAddRoute = Ember.Route.extend
  registerController: (->
    @get('container').register 'controller:calendarLists.add', Vosae.CalendarListEditController
  ).on "init"

  model: ->
    @store.createRecord('calendarList')

  setupController: (controller, model) ->
    acl = @store.createRecord('calendarAcl')
    acl.get('rules').createRecord
      'principal': @get("session.user")
      'role': 'OWNER'
    
    calendar = @store.createRecord('vosaeCalendar', {'acl': acl})

    model.get('reminders').createRecord()
    model.set 'calendar', calendar

    controller.set 'content', model

  renderTemplate: ->
    @_super()
    @render 'calendarList.edit.settings',
      into: 'tenant'
      outlet: 'outletPageSettings'

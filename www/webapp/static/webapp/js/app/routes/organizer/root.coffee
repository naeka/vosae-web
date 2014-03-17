Vosae.AppOrganizerRoute = Em.Route.extend
  setupController: ->
    Vosae.lookup('controller:application').set('currentRoute', 'organizer')

Vosae.CalendarListsRoute = Vosae.AppOrganizerRoute.extend()
Vosae.CalendarListRoute = Vosae.AppOrganizerRoute.extend()
Vosae.VosaeEventRoute = Vosae.AppOrganizerRoute.extend()
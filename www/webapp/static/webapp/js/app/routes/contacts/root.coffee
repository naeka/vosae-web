Vosae.AppContactsRoute = Vosae.SelectedTenantRoute.extend
  setupController: ->
    Vosae.lookup('controller:application').set('currentRoute', 'contacts')
    Vosae.lookup('controller:contactsShow') # Hack for contacts.totalCount

Vosae.ContactRoute = Vosae.AppContactsRoute.extend()
Vosae.ContactsRoute = Vosae.AppContactsRoute.extend()
Vosae.OrganizationRoute = Vosae.AppContactsRoute.extend()
Vosae.OrganizationsRoute = Vosae.AppContactsRoute.extend()
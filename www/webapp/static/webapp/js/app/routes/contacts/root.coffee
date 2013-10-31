Vosae.ContactRoute = Vosae.AppContactsRoute.extend
  renderTemplate: ->
    @render
     into: 'application'

Vosae.ContactsRoute = Vosae.AppContactsRoute.extend
  renderTemplate: ->
    @render
     into: 'application'

Vosae.OrganizationRoute = Vosae.AppContactsRoute.extend
  renderTemplate: ->
    @render
     into: 'application'

Vosae.OrganizationsRoute = Vosae.AppContactsRoute.extend
  renderTemplate: ->
    @render
     into: 'application'
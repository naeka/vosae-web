Vosae.ContactsShowView = Em.View.extend
  classNames: ["app-contacts", "page-list-contacts"]

  paginationAction: ->
    @controller.getNextPagination()

Vosae.ContactsShowSettingsView = Em.View.extend
  classNames: ["app-contacts", "page-settings", "page-list-contacts-settings"]
###
  This customer adapter is mainly used to handle the specific endpoint 'mark_as_read/'
###
Vosae.NotificationAdapter = Vosae.ApplicationAdapter.extend

  updateRecord: (store, type, record) ->
    typeKey = type.typeKey

    if type isnt Vosae.Notification
      typeKey = type.superclass.typeKey

    id = record.get "id"
    url = @buildURL(typeKey, id) + "mark_as_read/"

    @ajax url, "PUT"

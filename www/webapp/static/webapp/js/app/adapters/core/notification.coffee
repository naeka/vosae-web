###
  This customer adapter is mainly used to handle the specific endpoint 'mark_as_read/'
###
Vosae.NotificationAdapter = Vosae.ApplicationAdapter.extend
  find: (store, type, id) ->
    @ajax @buildURL("notification", id), 'GET'

  updateRecord: (store, type, record) ->
    id = record.get "id"
    url = @buildURL("notification", id) + "mark_as_read/"

    @ajax url, "PUT"

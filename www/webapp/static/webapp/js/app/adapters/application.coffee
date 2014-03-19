###
  Main adapter for the application.

  @class ApplicationAdapter
  @extends Vosae.ApplicationAdapter
  @namespace Vosae
  @module Vosae
###

Vosae.ApplicationAdapter = DS.EmbeddedAdapter.extend
  defaultSerializer: 'Vosae/application'
  host: Vosae.Config.APP_ENDPOINT
  namespace: Vosae.Config.API_NAMESPACE

  buildURL: (type, id) ->
    @_super(type, id) + "/"

  ###
    Called by the store when a newly created record is
    saved via the `save` method on a model record instance.

    The `createRecord` method serializes the record and makes an Ajax (HTTP POST) request
    to a URL computed by `buildURL`.

    We don't want to wrap record's data into an object with the record's typekey root.

    @method createRecord
    @param {DS.Store} store
    @param {subclass of DS.Model} type
    @param {DS.Model} record
    @returns {Promise} promise
  ###
  createRecord: (store, type, record) ->
    data = {}
    serializer = store.serializerFor type.typeKey

    serializer.serializeIntoHash(data, type, record, includeId: true).then (serialized) =>
      @ajax @buildURL(type.typeKey), "POST", data: serialized.object

  ###
    Called by the store when an existing record is saved
    via the `save` method on a model record instance.

    The `updateRecord` method serializes the record and makes an Ajax (HTTP PUT) request
    to a URL computed by `buildURL`.

    We don't want to wrap record's data into an object with the record's typekey root.

    @method updateRecord
    @param {DS.Store} store
    @param {subclass of DS.Model} type
    @param {DS.Model} record
    @returns {Promise} promise
  ###
  updateRecord: (store, type, record) ->
    data = {}
    serializer = store.serializerFor type.typeKey
    id = record.get 'id'

    serializer.serializeIntoHash(data, type, record).then (serialized) =>
      @ajax @buildURL(type.typeKey, id), "PUT", data: serialized.object

  ###
    Called by the store in order to fetch a JSON array for all
    of the records for a given type.

    The `findAll` method makes an Ajax (HTTP GET) request to a URL computed by `buildURL`, and returns a
    promise for the resulting payload.

    @method findAll
    @param {DS.Store} store
    @param {subclass of DS.Model} type
    @param {String} sinceToken
    @returns {Promise} promise
  ###
  findAll: (store, type, sinceToken) ->
    if sinceToken
      query =
        offset: sinceToken

    @ajax @buildURL(type.typeKey), 'GET', data: query

  ###
    Called by the store in order to fetch a JSON array for
    the unloaded records in a has-many relationship that were originally
    specified as IDs.

    For example, if the original payload looks like:

    ```js
    {
      "id": 1,
      "title": "Rails is omakase",
      "comments": [ 1, 2, 3 ]
    }
    ```

    The IDs will be passed as a URL-encoded, in this form:

    ```
    set/1;2;3/
    ```

    The `findMany` method makes an Ajax (HTTP GET) request to a URL computed by `buildURL`, and returns a
    promise for the resulting payload.

    @method findMany
    @param {DS.Store} store
    @param {subclass of DS.Model} type
    @param {Array} ids
    @returns {Promise} promise
  ###
  findMany: (store, type, ids) ->
    url = @buildURL(type.typeKey) + "set/"
    url = url + ids.join(";") + "/"

    @ajax(url, 'GET')

  pathForType: (type) ->
    Ember.String.decamelize(type)
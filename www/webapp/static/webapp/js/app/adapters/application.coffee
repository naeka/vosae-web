Vosae.ApplicationAdapter = DS.EmbeddedAdapter.extend
  defaultSerializer: 'Vosae/application'
  host: Vosae.Config.APP_ENDPOINT
  namespace: Vosae.Config.API_NAMESPACE

  buildURL: (type, id) ->
    @_super(type, id) + "/"

  pathForType: (type) ->
    Ember.String.decamelize(type)

  findAll: (store, type, sinceToken) ->
    if sinceToken
      query =
        offset: sinceToken

    @ajax(@buildURL(type.typeKey), 'GET', data: query)

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

    Many servers, such as Rails and PHP, will automatically convert this URL-encoded array
    into an Array for you on the server-side. If you want to encode the
    IDs, differently, just override this (one-line) method.

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
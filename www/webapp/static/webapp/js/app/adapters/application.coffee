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

    @ajax(this.buildURL(type.typeKey), 'GET', data: query)
Vosae.OrganizationsShowRoute = Ember.Route.extend
  beforeModel: ->
    meta = @store.metadataFor "organization"
    if !meta or !meta.get "hasBeenFetched"
      @store.find "organization"

  model: ->
    @store.all "organization"

  renderTemplate: ->
    @_super()
    @render 'organizations.show.settings',
      into: 'application'
      outlet: 'outletPageSettings'

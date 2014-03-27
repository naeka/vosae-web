Vosae.ContactsShowRoute = Ember.Route.extend
  beforeModel: ->
    meta = @store.metadataFor "contact"
    if !meta or !meta.get "hasBeenFetched"
      @store.find "contact"

  model: ->
    @store.all "contact"

  renderTemplate: ->
    @_super()
    @render 'contacts.show.settings',
      into: 'tenant'
      outlet: 'outletPageSettings'
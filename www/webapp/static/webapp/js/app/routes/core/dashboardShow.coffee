Vosae.DashboardShowRoute = Ember.Route.extend    
  beforeModel: ->
    meta = @store.metadataFor "timeline"
    # Only fetch `timeline` once
    if !meta or !meta.hasBeenFetched
      @store.findAll "timeline"

  model: ->
    promises = []
    for model in Vosae.Utilities.TIMELINE_MODELS
      promises.push @store.all(model)
    return Ember.RSVP.all promises
  
  setupController: (controller, model) ->
    controller.setProperties
      'content': null
      'unmergedContent': model

  # renderTemplate: ->
  #   @_super()
  #   @render 'dashboard.show.settings',
  #     into: 'application'
  #     outlet: 'outletPageSettings'
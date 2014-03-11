###
  The top level route. This route is entered when Vosae first boots up
  It will be in charge to fetch all dependencies we need such as
  `currencies` and `tenants` before the application is used by users.
  

  @class ApplicationRoute
  @extends Ember.Route
  @namespace Vosae
  @module Vosae
###

Vosae.ApplicationRoute = Ember.Route.extend
  model: ->
    # Fetch dependencies
    tenants = @store.findAll 'tenant'
    currencies = @store.findAll 'currency'

    Ember.RSVP.all([tenants, currencies])
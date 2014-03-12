###
  The main Vosae application

  @class Vosae
  @extends Ember.Application
###

window.Vosae = Em.Application.create
  LOG_TRANSITIONS: true
  LOG_TRANSITIONS_INTERNAL: true
  LOG_VIEW_LOOKUPS: true

  preWindowLocation: WINDOW_LOCATION_AT_START # See skeleton-head.html

  ###
    Lookup into the application to find instance of controller or store
  ###
  lookup: (path) ->
    @__container__.lookup(path)

  ###
    Application runner, each task must be accomplish before start routing
  ###
  run: ->
    Vosae.Utilities.updatePrototypes()
    Vosae.Utilities.addCSRFToken()
    Vosae.Utilities.setLanguage(LANGUAGE)
    Vosae.Utilities.configPlugins()
    
    @injectSession()
    @advanceReadiness()

  ###
    Inject session object into views, routes and controllers
  ###
  injectSession: ->
    this.register 'session:current', Vosae.Session, {singleton: true}
    this.inject 'view', 'session', 'session:current'
    this.inject 'route', 'session', 'session:current'
    this.inject 'controller', 'session', 'session:current'

###
  We need to defer readiness as long as we have
  dependencies to fetch on the API.
###
Vosae.deferReadiness()
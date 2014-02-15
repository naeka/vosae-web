###
  The main Vosae application

  @class Vosae
  @extends Ember.Application
###
window.Vosae = Em.Application.create
  preWindowLocation: window.preWindowLocation # See skeleton-head.html
  tenantsAreLoaded: false
  currenciesAreLoaded: false

  ###
    Lookup into the application to find instance of controller or store
  ###
  lookup: (path) ->
    @__container__.lookup(path)

  ###
    Application runner, each task must be accomplish before start routing
  ###
  run: ->
    @injectSession()
    Vosae.Utilities.updatePrototypes()
    Vosae.Utilities.addCSRFToken()
    Vosae.Utilities.setLanguage(LANGUAGE)
    Vosae.Utilities.configPlugins()
    @createMetaControllers()
    @getTenants()
    @getCurrencies()

  ###
    Inject session object into views, routes and controllers
  ###
  injectSession: ->
    this.register 'session:current', Vosae.Session, {singleton: true}
    this.inject 'view', 'session', 'session:current'
    this.inject 'route', 'session', 'session:current'
    this.inject 'controller', 'session', 'session:current'

  ###
    Meta controllers for models, should be moved elsewhere
  ###
  createMetaControllers: ->
    @set 'metaForContact' , Em.Object.createWithMixins Vosae.MetaControllerMixin
    @set 'metaForOrganization' , Em.Object.createWithMixins Vosae.MetaControllerMixin
    @set 'metaForQuotation' , Em.Object.createWithMixins Vosae.MetaControllerMixin
    @set 'metaForInvoice' , Em.Object.createWithMixins Vosae.MetaControllerMixin
    @set 'metaForItem' , Em.Object.createWithMixins Vosae.MetaControllerMixin
    @set 'metaForTimeline' , Em.Object.createWithMixins Vosae.MetaControllerMixin
    @set 'metaForNotification' , Em.Object.createWithMixins Vosae.MetaControllerMixin      
    @set 'metaForCurrency' , Em.Object.createWithMixins Vosae.MetaControllerMixin      
    @set 'metaForTenant' , Em.Object.createWithMixins Vosae.MetaControllerMixin
    @set 'metaForPurchaseOrder', Em.Object.createWithMixins Vosae.MetaControllerMixin
    @set 'metaForApiKey', Em.Object.createWithMixins Vosae.MetaControllerMixin

  ###
    Check that tenants and currencies have been fetched and loaded
  ###
  checkDataDependencies: ->
    depenciesAreLoaded = true
    depencies = ['tenantsAreLoaded', 'currenciesAreLoaded']

    depencies.forEach (dep) =>
      unless @get(dep)
        depenciesAreLoaded = false
    if depenciesAreLoaded
      @advanceReadiness()

  ###
    Fetch all tenants related to the current user
  ###
  getTenants: ->
    offset = @metaForTenant.getNextOffset()
    tenants = Vosae.Tenant.find(offset: offset)
    tenants.one "didLoad", @, ->
      if Vosae.metaForTenant.next
        @getTenants()
      else
        @set "tenantsAreLoaded", true
        @checkDataDependencies()
  
  ###
    Fetch all currencies
  ###
  getCurrencies: ->
    offset = @metaForCurrency.getNextOffset()
    currencies = Vosae.Currency.find(offset: offset)
    currencies.one "didLoad", @, ->
      if Vosae.metaForCurrency.next
        @getCurrencies()
      else
        @set 'currenciesAreLoaded', true
        @checkDataDependencies()

###
  We need to defer readiness as long as we have
  dependencies to fetch on the API.
###
Vosae.deferReadiness()
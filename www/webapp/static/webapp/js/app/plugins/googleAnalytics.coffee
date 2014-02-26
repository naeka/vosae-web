Ember.GoogleAnalyticsTrackingMixin = Ember.Mixin.create
  pageHasGaq: ->
    window._gaq and typeof window._gaq is "object"

  trackPageView: (page) ->
    if @pageHasGaq()
      unless page
        loc = window.location
        page = (if loc.hash then loc.hash.substring(1) else loc.pathname + loc.search)
      _gaq.push ["_trackPageview", @removeTenantFromPage(page)]
    return

  removeTenantFromPage: (page) ->
    tenantSlug = Vosae.lookup('session:current').get('tenant.slug')
    if tenantSlug and page.split('/')[1] is tenantSlug
      page = page.split('/')
      page.splice(1, 1)
      page = page.join('/')
    page

  trackEvent: (category, action) ->
    _gaq.push ["_trackEvent", category, action] if @pageHasGaq()
    return

Ember.Application.initializer
  name: "googleAnalytics"
  initialize: (container, application) ->
    router = container.lookup("router:main")
    router.on "didTransition", ->
      @trackPageView @get("url")
      return
    return

Ember.Router.reopen Ember.GoogleAnalyticsTrackingMixin
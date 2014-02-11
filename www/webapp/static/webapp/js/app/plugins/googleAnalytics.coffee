Ember.GoogleAnalyticsTrackingMixin = Ember.Mixin.create
  pageHasGa: ->
    window.ga and typeof window.ga is "function"

  trackPageView: (page) ->
    if @pageHasGa()
      unless page
        loc = window.location
        page = (if loc.hash then loc.hash.substring(1) else loc.pathname + loc.search)
      ga "send", "pageview", page
    return

  trackEvent: (category, action) ->
    ga "send", "event", category, action if @pageHasGa()
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
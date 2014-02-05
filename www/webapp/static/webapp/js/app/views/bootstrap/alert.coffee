Bootstrap.AlertMessage = Ember.View.extend Bootstrap.TypeSupport,
  classNames: ["alert", "alert-message"]
  baseClassName: "alert"
  title: gettext("Oh snap!")
  templateName: "bootstrap/alert"
  message: null
  removeAfter: null
  
  didInsertElement: ->
    removeAfter = Ember.get(this, "removeAfter")
    Ember.run.later this, "destroy", removeAfter if removeAfter > 0

  click: (event) ->
    target = event.target
    targetRel = target.getAttribute("rel")
    if targetRel is "close"
      @destroy()
      false
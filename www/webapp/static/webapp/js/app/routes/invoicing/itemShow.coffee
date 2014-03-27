Vosae.ItemShowRoute = Ember.Route.extend
  controllerName: "item"

  model: ->
    @modelFor("item")
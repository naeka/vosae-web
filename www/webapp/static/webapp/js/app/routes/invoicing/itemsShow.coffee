Vosae.ItemsShowRoute = Ember.Route.extend
  model: ->
    Vosae.Item.all()
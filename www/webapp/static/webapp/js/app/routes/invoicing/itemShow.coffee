Vosae.ItemShowRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.set 'content', @modelFor("item")
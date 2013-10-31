Vosae.VosaeEventShowRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.set 'content', @modelFor("vosaeEvent")
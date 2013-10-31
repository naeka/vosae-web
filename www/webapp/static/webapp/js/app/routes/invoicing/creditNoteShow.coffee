Vosae.CreditNoteShowRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.set 'content', @modelFor("creditNote")
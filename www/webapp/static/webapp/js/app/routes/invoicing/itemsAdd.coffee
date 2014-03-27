Vosae.ItemsAddRoute = Ember.Route.extend
  controllerName: "item"
  viewName: "itemEdit"

  model: ->
    @store.createRecord "item"

  setupController: (controller, model) ->
    controller.setProperties
      'content': model
      'taxes': @store.all("tax")
      'currencies': @store.all("currency")

  deactivate: ->
    model = @controller.get "content"
    model.rollback() if model
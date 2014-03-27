Vosae.ItemEditRoute = Ember.Route.extend
  controllerName: "item"

  model: ->
    @modelFor("item")

  setupController: (controller, model) ->
    controller.setProperties
      'content': model
      'taxes': @store.all("tax")
      'currencies': @store.all("currency")

  renderTemplate: ->
    @_super()
    @render 'item.edit.settings',
      into: 'tenant'
      outlet: 'outletPageSettings'

  deactivate: ->
    model = @controller.get "content"
    model.rollback() if model
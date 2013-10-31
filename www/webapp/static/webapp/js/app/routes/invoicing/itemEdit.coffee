Vosae.ItemEditRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.setProperties
      'content': @modelFor("item")
      'taxes': Vosae.Tax.all()
      'currencies': Vosae.Currency.all()

  renderTemplate: ->
    @_super()
    @render 'item.edit.settings',
      into: 'application'
      outlet: 'outletPageSettings'

  deactivate: ->
    item = @controller.get 'content'
    if item.get 'isDirty'
      item.get("transaction").rollback()
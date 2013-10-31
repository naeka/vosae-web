Vosae.ItemsAddRoute = Ember.Route.extend
  init: ->
    @_super()
    @get('container').register('controller:items.add', Vosae.ItemEditController)

  model: ->
    Vosae.Item.createRecord()

  setupController: (controller, model) ->
    controller.setProperties
      'content': model
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
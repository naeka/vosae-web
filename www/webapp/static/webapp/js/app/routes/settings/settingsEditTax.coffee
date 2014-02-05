Vosae.SettingsEditTaxRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.set('content', model)

  renderTemplate: ->
    @render 'settings.editTax',
      into: 'settings'
      outlet: 'content'

  deactivate: ->
    tax = @controller.get 'content'
    if tax.get 'isDirty'
      tax.get("transaction").rollback()
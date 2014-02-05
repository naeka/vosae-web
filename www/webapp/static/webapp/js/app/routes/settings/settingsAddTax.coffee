Vosae.SettingsAddTaxRoute = Ember.Route.extend
  init: ->
    @_super()
    @get('container').register('controller:settings.addTax', Vosae.SettingsEditTaxController)

  model: ->
    Vosae.Tax.createRecord()
      
  renderTemplate: ->
    @render 'settings.editTax',
      into: 'settings'
      outlet: 'content'
      controller: @controller

  deactivate: ->
    tax = @controller.get 'content'
    if tax.get 'isDirty'
      tax.get("transaction").rollback()
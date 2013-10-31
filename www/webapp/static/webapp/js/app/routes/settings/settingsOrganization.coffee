Vosae.SettingsOrganizationRoute = Ember.Route.extend
  model: ->
    @get('session.tenant')

  renderTemplate: ->
    @render 'settings.organization',
      into: 'settings'
      outlet: 'content'

    @render 'settings.organization.actions',
      into: 'settings'
      outlet: 'actions'
      controller: @controller

  deactivate: ->
    tenant = @controller.get 'content'
    if tenant.get 'isDirty'
      tenant.get("transaction").rollback()
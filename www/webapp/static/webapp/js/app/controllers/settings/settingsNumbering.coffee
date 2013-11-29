Vosae.SettingsNumberingController = Em.ObjectController.extend
  # Actions handlers
  actions:
    save: (tenantSettings) ->
      tenantSettings.get('transaction').commit()
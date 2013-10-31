Vosae.SettingsNumberingController = Em.ObjectController.extend
  save: (tenantSettings) ->
    tenantSettings.get('transaction').commit()
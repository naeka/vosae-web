Vosae.SettingsReportController = Em.ObjectController.extend
  actions:
    save: (reportSettings) ->
      reportSettings.get('transaction').commit()
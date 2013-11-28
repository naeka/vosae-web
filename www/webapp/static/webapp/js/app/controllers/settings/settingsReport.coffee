Vosae.SettingsReportController = Em.ObjectController.extend
  save: (reportSettings) ->
    reportSettings.get('transaction').commit()
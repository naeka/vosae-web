Vosae.SettingsDataLiberationController = Em.ArrayController.extend
  # Actions handlers
  actions:
    save: (dataLiberation) ->
      dataLiberation.get('transaction').commit()
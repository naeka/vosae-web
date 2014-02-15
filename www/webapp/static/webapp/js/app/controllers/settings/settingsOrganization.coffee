Vosae.SettingsOrganizationController = Em.ObjectController.extend
  # Actions handlers
  actions:
    save: (tenant)->
      tenant.get('transaction').commit()

    downloadTerms: (terms)->
      $.fileDownload(Vosae.Config.APP_ENDPOINT + terms.get('downloadLink'))
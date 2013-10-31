Vosae.SettingsOrganizationController = Em.ObjectController.extend
  save: (tenant)->
    tenant.get('transaction').commit()

  downloadTerms: (terms)->
    $.fileDownload(APP_ENDPOINT + terms.get('downloadLink'))
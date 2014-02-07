Vosae.SettingsExportView = Vosae.PageSettingsView.extend
  classNames: ["outlet-settings", "page-settings-export"]

  documentsTypes: Vosae.Components.Select.extend
    exportBinding: "export"
    contentBinding: "Vosae.exportDocumentsTypes"
    multiple: "true"
    containerCssClass: "green"
    optionValuePath: "content.value"
    optionLabelPath: "content.name" 
    change: ->
      unless Em.isEmpty @get('selection')
        console.log @get('selection').getEach('value').join(" ")
        @get('export').set 'documentsTypes', @get('selection').getEach('value').join(" ")



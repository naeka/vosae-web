Vosae.EntitiesController = Vosae.ArrayController.extend
  # Return a generated url to export data
  getExportFile: ->
    format = "vcard"
    tenantSlug = @get('session.tenant.slug')
    exportURL = "#{APP_ENDPOINT}#{@get('store').adapter.namespace}/"
  
    switch @constructor
      when Vosae.ContactsShowController
        exportURL += "contact/"
      when Vosae.OrganizationsShowController
        exportURL += "organization/"
    
    exportURL += "export/#{format}/?x_vc=#{tenantSlug}"
    
    $.fileDownload(exportURL)

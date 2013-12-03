Vosae.EntitiesController = Vosae.ArrayController.extend
  actions:
    # Return a generated url to export data
    getExportFile: ->
      format = "vcard"
      tenantSlug = @get('session.tenant.slug')
      exportURL = "#{APP_ENDPOINT}#{@get('store').adapter.namespace}/"
    
      switch @constructor.toString()
        when Vosae.ContactsShowController.toString()
          exportURL += "contact/"
        when Vosae.OrganizationsShowController.toString()
          exportURL += "organization/"
      
      exportURL += "export/#{format}/?x_vc=#{tenantSlug}"
      
      $.fileDownload(exportURL)

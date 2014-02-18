###
  A custom array controller for a collection of `Vosae.Entity` based records.

  @class EntitiesController
  @extends Vosae.ArrayController
  @namespace Vosae
  @module Vosae
###

Vosae.EntitiesController = Vosae.ArrayController.extend
  actions:
    # Return a generated url to export data
    getExportFile: ->
      format = "vcard"
      tenantSlug = @get('session.tenant.slug')
      exportURL = "#{Vosae.Config.APP_ENDPOINT}/#{Vosae.Config.API_NAMESPACE}/"
    
      switch @constructor.toString()
        when Vosae.ContactsShowController.toString()
          exportURL += "contact/"
        when Vosae.OrganizationsShowController.toString()
          exportURL += "organization/"

      exportURL += "export/#{format}/?x_tenant=#{tenantSlug}"

      $.fileDownload(exportURL)

###
  A custom array controller for a collection of `Vosae.Entity` based records.

  @class EntitiesController
  @extends Vosae.ArrayController
  @namespace Vosae
  @module Vosae
###

Vosae.EntitiesController = Vosae.ArrayController.extend
  exportFormat: "vcard"

  actions:
    ###
      Generate an ajax download with the url from @getExportURL
    ###
    getExportFile: ->
      $.fileDownload @getExportURL()

  ###
    Build the URL that will be used by the library `fileDownload`
  ###
  getExportURL: ->
    tenantSlug = @get "session.tenant.slug"
    url = "#{Vosae.Config.APP_ENDPOINT}/#{Vosae.Config.API_NAMESPACE}/"
    url + "#{@relatedType}/export/#{@exportFormat}/?x_tenant=#{tenantSlug}"
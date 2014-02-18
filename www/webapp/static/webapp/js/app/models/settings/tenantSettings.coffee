###
  A data model that represents settings for a tenant

  @class TenantSettings
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.TenantSettings = Vosae.Model.extend
  core: DS.belongsTo('Vosae.CoreSettings')
  invoicing: DS.belongsTo('Vosae.InvoicingSettings')

  didUpdate: ->
    message = gettext "Invoicing settings have been successfully updated"
    Vosae.SuccessPopupComponent.open
      message: message


Vosae.Adapter.map "Vosae.TenantSettings",
  core:
    embedded: "always"
  invoicing:
    embedded: "always"
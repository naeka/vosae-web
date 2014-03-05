###
  A data model that represents settings for a tenant

  @class TenantSettings
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.TenantSettings = Vosae.Model.extend
  core: DS.belongsTo('coreSettings')
  invoicing: DS.belongsTo('invoicingSettings')

  didUpdate: ->
    message = gettext "Invoicing settings have been successfully updated"
    Vosae.SuccessPopupComponent.open
      message: message
###
  A data model that represents settings for core application

  @class CoreSettings
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.CoreSettings = Vosae.Model.extend
  quotas: DS.belongsTo('storageQuotasSettings')
###
  A data model that represents settings for storage quotas

  @class StorageQuotasSettings
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.StorageQuotasSettings = Vosae.Model.extend
  allocatedSpace: DS.attr 'number'
  usedSpace: DS.attr 'number'

  usedSpacePercent: (->
    @get('usedSpace') / @get('allocatedSpace') * 100
  ).property('allocatedSpace', 'usedSpace')
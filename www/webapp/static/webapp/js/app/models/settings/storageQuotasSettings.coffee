Vosae.StorageQuotasSettings = DS.Model.extend
  allocatedSpace: DS.attr 'number'
  usedSpace: DS.attr 'number'

  usedSpacePercent: (->
    @get('usedSpace') / @get('allocatedSpace') * 100
  ).property('allocatedSpace', 'usedSpace')
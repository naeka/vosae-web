Vosae.CoreSettings = DS.Model.extend
  quotas: DS.belongsTo('Vosae.StorageQuotasSettings')

Vosae.Adapter.map "Vosae.CoreSettings",
  quotas:
    embedded: "always"
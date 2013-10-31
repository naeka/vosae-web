Vosae.SpecificPermission = DS.Model.extend
  name: DS.attr("string")
  value: DS.attr("boolean")

Vosae.SpecificPermission.reopen
  user: DS.belongsTo('Vosae.User')
  group: DS.belongsTo('Vosae.Group')
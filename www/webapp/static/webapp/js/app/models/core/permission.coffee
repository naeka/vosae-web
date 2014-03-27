###
  A data model that represents a specific permission 

  @class SpecificPermission
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.SpecificPermission = Vosae.Model.extend
  name: DS.attr("string")
  value: DS.attr("boolean")

# Vosae.SpecificPermission.reopen
#   user: DS.belongsTo('Vosae.User')
#   group: DS.belongsTo('Vosae.Group')
###
  A data model that represents a calendar acl

  @class CalendarAcl
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.CalendarAcl = Vosae.Model.extend
  rules: DS.hasMany('Vosae.CalendarAclRule')


Vosae.Adapter.map "Vosae.CalendarAcl",
  rules:
    embedded: "always"
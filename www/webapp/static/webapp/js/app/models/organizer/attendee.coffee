###
  A data model that represents an attendee

  @class Attende
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.Attendee = Vosae.Model.extend
  email: DS.attr('string')
  displayName: DS.attr('string')
  organizer: DS.attr('boolean')
  vosaeUser: DS.belongsTo('Vosae.User')
  photoUri: DS.attr('string')
  optional: DS.attr('boolean')
  responseStatus: DS.attr('string')
  comment: DS.attr('string')

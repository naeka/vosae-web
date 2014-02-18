###
  A data model that represents an organization

  @class Organization
  @extends Vosae.Entity
  @namespace Vosae
  @module Vosae
###

Vosae.Organization = Vosae.Entity.extend
  corporateName: DS.attr('string')
  contacts: DS.hasMany('Vosae.Contact')
  # tags: DS.attr('string')
 
  getErrors: ->
    errors = []
    unless @get('corporateName')
      errors.addObject gettext('Corporate name field must not be blank')
    return errors


Vosae.Adapter.map "Vosae.Organization",
  addresses:
    embedded: "always"
  emails:
    embedded: "always"
  phones:
    embedded: "always"
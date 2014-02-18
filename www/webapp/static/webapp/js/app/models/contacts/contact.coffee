###
  A data model that represents a contact

  @class Contact
  @extends Vosae.Entity
  @namespace Vosae
  @module Vosae
###

Vosae.Contact = Vosae.Entity.extend
  name: DS.attr("string")
  firstname: DS.attr("string")
  additionalNames: DS.attr("string")
  civility: DS.attr("string", defaultValue: null)
  birthday: DS.attr("date")
  role: DS.attr("string")
  organization: DS.belongsTo("Vosae.Organization")

  fullName: (->
    firstname = @get('firstname')
    name = @get('name')
    if firstname and name
      return firstname + ' ' + name
    else if name and not firstname
      return name
    else if firstname and not name
      return firstname
    ''
  ).property("firstname", "name")

  getErrors: ->
    errors = []
    unless @get('name')
      errors.addObject gettext('Name field must not be blank')
    unless @get('firstname')
      errors.addObject gettext('Firstname field must not be blank')
    return errors


Vosae.Adapter.map "Vosae.Contact",
  addresses:
    embedded: "always"
  emails:
    embedded: "always"
  phones:
    embedded: "always"
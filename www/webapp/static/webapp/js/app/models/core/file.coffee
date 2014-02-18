###
  A data model that represents a file

  @class File
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.File = Vosae.Model.extend
  name: DS.attr("string")
  size: DS.attr("number")
  sha1_checksum: DS.attr("string")
  downloadLink: DS.attr("string")
  streamLink: DS.attr("string")
  ttl: DS.attr('number')
  createdAt: DS.attr('datetime')
  modifiedAt: DS.attr('datetime')
  issuer: DS.belongsTo("Vosae.User")

  # Returns the created date formated
  displayCreatedAt: (->
    if @get("createdAt")?
      return moment(@get("createdAt")).format "LL"
    return pgettext("date", "undefined")
  ).property("createdAt")

  # Returns the modified date formated
  displayModifiedAt: (->
    if @get("modifiedAt")?
      return moment(@get("modifiedAt")).format "LL"
    return pgettext("date", "undefined")
  ).property("modifiedAt")
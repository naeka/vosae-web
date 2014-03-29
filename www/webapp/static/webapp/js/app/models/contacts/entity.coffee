###
  A data model that represents an entity

  @class Entity
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.Entity = Vosae.Model.extend
  photoSource: DS.attr("string")
  photoUri: DS.attr("string")
  gravatarMail: DS.attr("string")
  note: DS.attr("string")
  status: DS.attr("string")
  private: DS.attr("boolean", defaultValue: false)
  addresses: DS.hasMany("vosaeAddress", async: true)
  emails: DS.hasMany("vosaeEmail", async: true)
  phones: DS.hasMany("vosaePhone", async: true)
  creator: DS.belongsTo("user")
  photo: DS.belongsTo("file", async: true)

  isUploading: false

  # Return true if entity has been created by current Vosae.User
  isOwned: (->
    @get('creator') is @get("store.session.user")
  ).property 'creator'

  didCreate: ->
    message = switch @constructor.toString()
      when Vosae.Contact.toString()
        gettext 'Your contact has been successfully created'
      when Vosae.Organization.toString()
        gettext 'Your organization has been successfully created'
    Vosae.SuccessPopup.open
      message: message

  didUpdate: ->
    message = switch @constructor.toString()
      when Vosae.Contact.toString()
        gettext 'Your contact has been successfully updated'
      when Vosae.Organization.toString()
        gettext 'Your organization has been successfully updated'
    Vosae.SuccessPopup.open
      message: message

  didDelete: ->
    message = switch @constructor.toString()
      when Vosae.Contact.toString()
        gettext 'Your contact has been successfully deleted'
      when Vosae.Organization.toString()
        gettext 'Your organization has been successfully deleted'
    Vosae.SuccessPopup.open
      message: message
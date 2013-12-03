Vosae.Entity = DS.Model.extend
  photoSource: DS.attr("string")
  photoUri: DS.attr("string")
  gravatarMail: DS.attr("string")
  note: DS.attr("string")
  private: DS.attr("boolean", defaultValue: false)
  addresses: DS.hasMany("Vosae.Address")
  emails: DS.hasMany("Vosae.Email")
  phones: DS.hasMany("Vosae.Phone")
  creator: DS.belongsTo("Vosae.User")
  photo: DS.belongsTo("Vosae.File")
  status: DS.attr("string")

  isUploading: false

  isOwned: (->
    # Return true if entity has been created by current Vosae.User
    if @get('creator') is Vosae.lookup("session:current").get('user')
      return true
    false
  ).property 'creator'

  didCreate: ->
    message = switch @constructor.toString()
      when Vosae.Contact.toString()
        gettext 'Your contact has been successfully created'
      when Vosae.Organization.toString()
        gettext 'Your organization has been successfully created'
    Vosae.SuccessPopupComponent.open
      message: message

  didUpdate: ->
    message = switch @constructor.toString()
      when Vosae.Contact.toString()
        gettext 'Your contact has been successfully updated'
      when Vosae.Organization.toString()
        gettext 'Your organization has been successfully updated'
    Vosae.SuccessPopupComponent.open
      message: message

  didDelete: ->
    message = switch @constructor.toString()
      when Vosae.Contact.toString()
        gettext 'Your contact has been successfully deleted'
      when Vosae.Organization.toString()
        gettext 'Your organization has been successfully deleted'
    Vosae.SuccessPopupComponent.open
      message: message
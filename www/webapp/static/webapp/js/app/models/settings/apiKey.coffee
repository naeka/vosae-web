Vosae.ApiKey = DS.Model.extend
  label: DS.attr('string')
  key: DS.attr('string') 
  createdAt: DS.attr('datetime')

  didCreate: ->
    message = gettext 'Your API key has been successfully created'
    Vosae.SuccessPopupComponent.open
      message: message

  didDelete: ->
    message = gettext 'Your API key has been successfully deleted'
    Vosae.SuccessPopupComponent.open
      message: message
Vosae.ApiKey = DS.Model.extend
  label: DS.attr('string')
  key: DS.attr('string') 
  createdAt: DS.attr('datetime')

  # becameInvalid: ->
  #   alert "#{@get('errors')}"
  #   @send('becameValid')

  didCreate: ->
    message = gettext 'Your API key has been successfully created'
    Vosae.SuccessPopupComponent.open
      message: message

  didUpdate: ->
    message = gettext 'Your API key has been successfully updated'
    Vosae.SuccessPopupComponent.open
      message: message

  didDelete: ->
    message = gettext 'Your API key has been successfully deleted'
    Vosae.SuccessPopupComponent.open
      message: message
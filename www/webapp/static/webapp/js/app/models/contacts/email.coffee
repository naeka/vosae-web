Vosae.Email = DS.Model.extend
  type: DS.attr("string", defaultValue: 'WORK')
  email: DS.attr('string')

  displayType: (->
    obj = Vosae.emailTypeChoice.findProperty('value', @get('type'))
    if obj
      return obj.get('name')
    ''
  ).property()

  getErrors: ->
    errors = []
    unless @get('email')
      errors.addObject gettext('Email field must not be blank')
    return errors


Vosae.Email.reopen
  contact: DS.belongsTo('Vosae.Contact')
  organization: DS.belongsTo('Vosae.Organization')
Vosae.CalendarAcl = DS.Model.extend
  rules: DS.hasMany('Vosae.CalendarAclRule')

Vosae.CalendarAclRule = DS.Model.extend
  principal: DS.belongsTo('Vosae.User')
  role: DS.attr('string', defaultValue: 'NONE')

  displayRole: (->
    # Return a formated `role`
    if @get 'role'
      return Vosae.Config.calendarAclRuleRoles.findProperty('value', @get('role')).get('displayName')
    return ''
  ).property 'role'

Vosae.Adapter.map "Vosae.CalendarAcl",
  rules:
    embedded: "always"
###
  A data model that represents a calendar acl rule

  @class CalendarAclRule
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.CalendarAclRule = Vosae.Model.extend
  principal: DS.belongsTo('Vosae.User')
  role: DS.attr('string', defaultValue: 'NONE')

  displayRole: (->
    # Return a formated `role`
    if @get 'role'
      return Vosae.Config.calendarAclRuleRoles.findProperty('value', @get('role')).get('displayName')
    return ''
  ).property 'role'
###
  A data model that represents a group of permissions

  @class Group
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.Group = Vosae.Model.extend
  name: DS.attr('string')
  createdAt: DS.attr('datetime')
  permissions: DS.attr('array', defaultValue: [])
  createdBy: DS.belongsTo('user')

  # This method returns a <Vosae.Permissions> if 
  # `permissions` contains the permission name
  # permissionsContains: (perm) ->
  #   if @get('permissions.length')
  #     console.log perm
  #     return @get('permissions').filterProperty('name', perm).get('firstObject')
  #   return false

  # This method load `permissions` from a <Vosae.Group>
  # into the this group.
  loadPermissionsFromGroup: (group) ->
    if group and group.get('permissions')
      @set('permissions', group.get('permissions'))
      @trigger('permissionsHasBeenLoaded')

  didCreate: ->
    message = gettext 'The group has been successfully created'
    Vosae.SuccessPopup.open
      message: message

  didUpdate: ->
    message = gettext 'The group has been successfully updated'
    Vosae.SuccessPopup.open
      message: message

  didDelete: ->
    message = gettext 'The group has been successfully deleted'
    Vosae.SuccessPopup.open
      message: message
###
  A data model that represents a user

  @class User
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.User = Vosae.Model.extend
  email: DS.attr('string')
  fullName: DS.attr('string')
  groups: DS.hasMany('Vosae.Group')
  photoUri: DS.attr('string')
  permissions: DS.attr('array', defaultValue: [])
  specificPermissions: DS.hasMany('Vosae.SpecificPermission')
  settings: DS.belongsTo('Vosae.UserSettings')
  status: DS.attr('string')

  getStatus: (->
    statusValue = @get('status')
    statusLabel = Vosae.Config.userStatutes.findProperty 'value', statusValue
    if statusLabel?
      return statusLabel.get 'label'
    return gettext('Unknown')
  ).property('status')

  getFullName: (->
    fullName = @get 'fullName'
    if fullName
      return fullName
    return gettext 'To define'
  ).property 'fullName'

  # This method returns true if `permissions`
  # array contains the permission `@perm` 
  permissionsContains: (perm) ->
    if @get('permissions') and @get('permissions').contains(perm)
      return true
    false
  
  # This method returns a <Vosae.SpecificPermissions> if 
  # `specificPermissions` contains the permission name
  specificPermissionsContains: (perm) ->
    if @get('specificPermissions') and @get('specificPermissions.length')
      permObj = @get('specificPermissions').findProperty('name', perm)
      return permObj if permObj
    false

  # This method merged all `groups` permissions 
  # into the `permissions` array
  mergeGroupsPermissions: ->
    newPermissions = []
    
    if @get('groups.length')
      @get('groups').forEach (group) =>
        group.get('permissions').forEach (perm) =>
          if not newPermissions.contains(perm)
            newPermissions.addObject(perm)
            
          # Check if current permission was in `speficifPermissions`
          # then delete the specificPermission if it was granted
          # because it's now an acquired permission.
          specificPerm = @get('specificPermissions').filterProperty('name', perm).get('firstObject')
          
          if specificPerm and specificPerm.get('value')
            @get('specificPermissions').removeObject(specificPerm)

    @set('permissions', newPermissions)
    @trigger('groupsHasBeenMerged')

  didCreate: ->
    message = gettext 'The user has been successfully created'
    Vosae.SuccessPopupComponent.open
      message: message

  didUpdate: ->
    message = gettext 'The user has been successfully updated'
    Vosae.SuccessPopupComponent.open
      message: message

  didDelete: ->
    message = gettext 'The user has been successfully deleted'
    Vosae.SuccessPopupComponent.open
      message: message


Vosae.Adapter.map "Vosae.User",
  specificPermissions:
    embedded: 'always'
  settings:
    embedded: 'always'
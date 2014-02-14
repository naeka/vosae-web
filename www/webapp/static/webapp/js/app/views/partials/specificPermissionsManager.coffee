###
  This view is used to render all permissions and bind
  it with attr `permissions` and `specificPermissions`
  of a <Vosae.User> instance.

  @class SpecificPermissionsManager 
  @extends Ember.View
  @namespace Vosae
  @module Vosae
###

Vosae.SpecificPermissionsManager = Em.View.extend
  templateName: 'edit-specific-permissions-block'
  allPermissions: Vosae.permissions

  ###
    This view will be render for each permission's module
  ###
  specificPermissionsModuleView: Em.View.extend
    templateName: 'edit-specific-permissions-module-block'

    permSwitchView: Vosae.SwitchView.extend
      checkbox: Em.Checkbox.extend
        classNames: ["onoffswitch-checkbox"]
        freezeCheckedObserver: false

        setPerm: ->
          perm = @get('parentView.perm')
          specificPermissions = @get('parentView.specificPermissions')
          user = specificPermissions.get('owner')
          specificPerm = user.specificPermissionsContains(perm)

          if user.permissionsContains(perm)
            if specificPerm
              if specificPerm.get('value')
                @set('checked', true)
              else
                @set('checked', false)
            else
              @set('checked', true)

          else
            if specificPerm
              if specificPerm.get('value')
                @set('checked', true)
              else
                @set('checked', false)
            else
              @set('checked', false)

        addCheckedObserver: ->
          @addObserver 'checked', ->
            if not @get('freezeCheckedObserver')
              perm = @get('parentView.perm')
              specificPermissions = @get('parentView.specificPermissions')
              user = specificPermissions.get('owner')
              specificPerm = user.specificPermissionsContains(perm)

              if specificPerm
                specificPerm.toggleProperty('value')
              else
                specificPermissions.createRecord(name: perm, value: @get('checked'))

        didInsertElement: ->
          @get('parentView').$().find('label').attr('for', @get('elementId'))

          @setPerm()
          @addCheckedObserver()

          # Get user from `specificPermisisons` hasMany
          # This observer should be fired only when `groups` of 
          # the current <Vosae.User> has been updated
          user = @get('parentView.specificPermissions.owner')
          user.on "groupsHasBeenMerged", @, ->
            @set('freezeCheckedObserver', true)
            @setPerm()
            @set('freezeCheckedObserver', false)

        destroy: ->
          @removeObserver('checked')
          @_super()

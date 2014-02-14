###
  This view is used to render all permissions and bind
  it with attr `permissions` of a <Vosae.Group> instance.

  @class PermissionsManager
  @extends Ember.View
  @namespace Vosae
  @module Vosae
###

Vosae.PermissionsManager = Em.View.extend
  templateName: 'edit-permissions-block'
  allPermissions: Vosae.permissions

  ###
    This view will be render for each permission's module
  ###
  permissionsModuleView: Em.View.extend
    templateName: 'edit-permissions-module-block'

    permSwitchView: Vosae.SwitchView.extend
      checkbox: Em.Checkbox.extend
        classNames: ["onoffswitch-checkbox"]
        freezeCheckedObserver: false

        didInsertElement: ->
          @get('parentView').$().find('label').attr('for', @get('elementId'))

          @setPerm()
          @addCheckedObserver()

          # This observer should be fired only when user want to load
          # permissions from a <Vosae.Group> into the current group
          group = @get('parentView.group')
          group.on "permissionsHasBeenLoaded", @, ->
            @set('freezeCheckedObserver', true)
            @setPerm()
            @set('freezeCheckedObserver', false)

        setPerm: ->
          perm = @get('parentView.perm')
          permissions = @get('parentView.group.permissions')

          if permissions.contains(perm)
            @set('checked', true)
          else
            @set('checked', false)

        addCheckedObserver: ->
          @addObserver 'checked', ->
            if not @get('freezeCheckedObserver')
              perm = @get('parentView.perm')
              group = @get('parentView.group')
              permissions = @get('parentView.group.permissions')

              if @get('checked')
                if not permissions.contains(perm)
                  permissions.addObject(perm)
              else
                if permissions.contains(perm)
                  permissions.removeObject(perm)
              if group.get 'id'
                group.set 'currentState', DS.RootState.loaded.updated.uncommitted
              else
                group.set 'currentState', DS.RootState.loaded.created.uncommitted

        destroy: ->
          @removeObserver('checked')
          @_super()
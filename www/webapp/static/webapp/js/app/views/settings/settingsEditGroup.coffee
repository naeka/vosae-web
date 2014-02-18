Vosae.SettingsEditGroupView = Vosae.PageSettingsView.extend
  classNames: ["outlet-settings"]

  didInsertElement: ->
    @_super()
    # Focus on first input text
    @.$().find('.ember-text-field').first().focus()

  # This view generates a template with all permissions
  # grouped by modules. Each permission is binded to
  # the `permissions` array of the <Vosae.Group> record
  
  groupPermissionsView: Vosae.PermissionsManager.extend()


  loadPermissions: Vosae.Select.extend
    change: ->
      if @get('group') and @get('selection')
        @get('group').loadPermissionsFromGroup(@get('selection'))
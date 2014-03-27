Vosae.SettingsEditUserView = Vosae.PageSettingsView.extend
  classNames: ["outlet-settings"]

  didInsertElement: ->
    @_super()
    # Focus on first input text
    # @.$().find('.ember-text-field').first().focus()

  # This view generates a template with all permissions
  # grouped by modules. Each permission is binded to
  # the `permissions` array of the <Vosae.User> record
  
  userSpecificPermissionsView: Vosae.SpecificPermissionsManager.extend()

  groupsField: Vosae.Select.extend
    change: ->
      # Now we have to merge groups permissions into <Vosae.User.Permissions>
      @get('selection.owner').mergeGroupsPermissions()
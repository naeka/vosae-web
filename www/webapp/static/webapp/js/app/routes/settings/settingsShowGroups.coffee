Vosae.SettingsShowGroupsRoute = Ember.Route.extend
  model: ->
    @store.all("group").filter (group) =>
      group if group.get('createdBy')
Vosae.SettingsShowGroupsRoute = Ember.Route.extend
  model: ->
    @store.all("group")
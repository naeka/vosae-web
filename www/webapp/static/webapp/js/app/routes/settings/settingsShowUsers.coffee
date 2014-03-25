Vosae.SettingsShowUsersRoute = Ember.Route.extend
  model: ->
    @store.all("user")
Vosae.QuotationsShowRoute = Ember.Route.extend
  model: ->
    Vosae.Quotation.all()
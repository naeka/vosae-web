Vosae.InvoicesShowRoute = Ember.Route.extend
  model: ->
    Vosae.Invoice.all()
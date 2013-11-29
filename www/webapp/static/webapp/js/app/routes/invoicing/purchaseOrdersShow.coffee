Vosae.PurchaseOrdersShowRoute = Ember.Route.extend
  model: ->
    Vosae.PurchaseOrder.all()
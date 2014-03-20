###
  Custom array controller for a collection of `Vosae.Item` records.

  @class ItemsShowController
  @extends Vosae.ArrayController
  @namespace Vosae
  @module Vosae
###

Vosae.ItemsShowController = Vosae.ArrayController.extend
  relatedType: "item"
  sortProperties: ['reference']
  sortAscending: false
###
  A custom array controller for a collection of `Vosae.Contact` records.

  @class ContactsShowController
  @extends Vosae.EntitiesController
  @namespace Vosae
  @module Vosae
###

Vosae.ContactsShowController = Vosae.EntitiesController.extend
  relatedType: "contact"
  sortProperties: ['name']
  sortAscending: true
###
  A custom object controller for a `Vosae.Organization` record.

  @class OrganizationShowController
  @extends Vosae.EntityController
  @namespace Vosae
  @module Vosae
###

Vosae.OrganizationShowController = Vosae.EntityController.extend
  orderedContacts: (->
    Ember.ArrayProxy.createWithMixins Ember.SortableMixin,
      sortProperties: ['name']
      content: @get('content.contacts')
  ).property('content.contacts', 'content.contacts.@each')
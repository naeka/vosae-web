Vosae.OrganizationShowController = Vosae.EntityController.extend
  orderedContacts: (->
    Ember.ArrayProxy.createWithMixins Ember.SortableMixin,
      sortProperties: ['name']
      content: @get('content.contacts')
  ).property('content.contacts', 'content.contacts.@each')
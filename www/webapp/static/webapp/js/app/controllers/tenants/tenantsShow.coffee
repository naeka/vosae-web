###
  Custom controller for a collection of `Vosae.Tenant` records.

  @class TenantsShowController
  @extends Em.ArrayController
  @namespace Vosae
  @module Vosae
###

Vosae.TenantsShowController = Em.ArrayController.extend
  needs: ['realtime']

  # Returns an array with all tenants excluded the current one
  otherTenants: (->
    array = []
    if @get('content') and @get('content.length')
      @get('content').filter (tenant) =>
        unless tenant.get('slug') is @get('session.tenant').get('slug')
          array.pushObject tenant
    array
  ).property('content', 'content.length')


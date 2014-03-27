###
  Controller for resource tenant

  @class TenantController
  @extends Ember.Controller
  @namespace Vosae
  @module Vosae
###

Vosae.TenantController = Ember.ObjectController.extend
  needs: ['notifications', 'search', 'realtime', 'tenantsShow']

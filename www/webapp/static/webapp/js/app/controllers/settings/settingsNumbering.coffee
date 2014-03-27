###
  Custom controller for a `Vosae.InvoicingNumberingSettings` record.

  @class SettingsNumberingController
  @extends Ember.ObjectController
  @namespace Vosae
  @module Vosae
###

Vosae.SettingsNumberingController = Em.ObjectController.extend
  actions:
    save: (tenantSettings) ->
      tenantSettings.save()
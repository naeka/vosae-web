###
  Custom controller for a `Vosae.ReportSettings` record.

  @class SettingsReportController
  @extends Ember.ObjectController
  @namespace Vosae
  @module Vosae
###

Vosae.SettingsReportController = Em.ObjectController.extend
  actions:
    save: (reportSettings) ->
      reportSettings.save()
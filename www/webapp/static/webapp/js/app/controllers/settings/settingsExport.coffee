Vosae.SettingsExportController = Em.ArrayController.extend
  
  filteredExport: (->
    exports = @get('content').filter (exp) ->
      exp if exp.get("id") and not exp.get("isDeleted")
    return exports
  ).property('content.@each', 'content.length', 'content.@each.id')

  # Actions handlers
  actions:
    save: (exp) ->
      exp.one "didCreate", @, ->
        @notifyPropertyChange('content.length')
      exp.get('transaction').commit()

    # delete: (export) ->
    #   Vosae.ConfirmPopupComponent.open
    #     message: gettext 'Do you really want to revoke this API key?'
    #     callback: (opts, event) =>
    #       if opts.primary
    #         export.deleteRecord()
    #         export.get('transaction').commit()

    # add: ->
    #   transaction = @get('store').transaction()
    #   @setProperties
    #     content: transaction.createRecord(Vosae.export)
    #     exports: Vosae.Export.all()

Vosae.InvoicingNumberingSettings = DS.Model.extend
  scheme: DS.attr('string')
  separator: DS.attr('string')
  dateFormat: DS.attr('string')
  fyReset: DS.attr('boolean')

  preview: (->
    if @get('scheme') is "N"
      preview = "00000"
    else
      format = Vosae.invoicingDateFormats.findProperty('value', @get('dateFormat'))
      preview = moment().format(format.get('label'))
      preview += @get('separator') + "00000"
    preview
  ).property('scheme','dateFormat','separator')

  schemeIsNumber: (->
    return true if @get('scheme') is "N"
    false
  ).property('scheme')
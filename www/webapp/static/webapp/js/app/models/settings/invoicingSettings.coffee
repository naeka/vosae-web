###
  A data model that represents settings for invoicing application

  @class InvoicingSettings
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.InvoicingSettings = Vosae.Model.extend
  supportedCurrencies: DS.hasMany('Vosae.Currency')
  defaultCurrency: DS.belongsTo('Vosae.Currency')
  fyStartMonth: DS.attr('number')
  invTaxesApplication: DS.attr('string')
  quotationValidity: DS.attr('number')
  paymentConditions: DS.attr('string')
  customPaymentConditions: DS.attr('string')
  lateFeeRate: DS.attr('number')
  acceptedPaymentTypes: DS.attr('paymentTypesArray')
  downPaymentPercent: DS.attr('number')
  automaticReminders: DS.attr('boolean')
  automaticRemindersText: DS.attr('string')
  automaticRemindersSendCopy: DS.attr('boolean')
  numbering: DS.belongsTo('Vosae.InvoicingNumberingSettings')

  acceptedPaymentTypesFormatted: (->
    paymentTypes = @get('acceptedPaymentTypes')
    if not Em.isEmpty paymentTypes
      return paymentTypes.getEach('label').join(", ").toLowerCase()
    return gettext('undefined')
  ).property('acceptedPaymentTypes')

  lateFeeRateFormated: (->
    lateFeeRate = @get("lateFeeRate")
    if lateFeeRate?
      return accounting.formatNumber(lateFeeRate, precision: 2)
    return
  ).property("lateFeeRate")

  currentFyStartAt: (->
    start = moment.utc().startOf('year').month(@get('fyStartMonth'))
    if @get('fyStartMonth') > (new Date()).getMonth()
      start.subtract('years', 1)
    start
  ).property('fyStartMonth')
    
  currentFyStartYear: (->
    @get('currentFyStartAt').year()
  ).property('currentFyStartAt')


Vosae.Adapter.map "Vosae.InvoicingSettings",
  numbering:
    embedded: "always"
###
  A data model that represents a phone

  @class Phone
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.VosaePhone = Vosae.Model.extend
  type: DS.attr("string", defaultValue: 'WORK')
  subtype: DS.attr("string")
  phone: DS.attr("string")

  typeIsWork: (->
    # Return true if phone type is WORK
    if @get("type") is "WORK" then true else false
  ).property("type")

  typeIsHome: (->
    # Return true if phone type is HOME
    if @get("type") is "HOME" then true else false
  ).property("type")
  
  displayPhone: (->
    # TODO format phone number according to his country
    @get("phone")
  ).property("phone")

  combinedType: (->
    # Return combined types
    combined = ""
    type = @get("type")
    subtype = @get("subtype")
    if type then combined += "#{type}"
    if subtype then combined += "-#{subtype}"
    combined
  ).property("type", "subtype")
  
  displayCombinedType: (->
    # Display the combined type
    obj = Vosae.Config.phoneCombinedTypes.findProperty('value', @get("combinedType"))
    if obj then obj.get('name') else ''
  ).property("combinedType")

  combinedTypeChanged: (string) ->
    # Set type and subtype from a combined type
    obj = Vosae.Config.phoneCombinedTypes.findProperty('value', string)
    if obj
      @set "type", obj.get("type")
      @set "subtype", obj.get("subtype")
    else
      @set "type", null
      @set "subtype", null

  getErrors: ->
    errors = []
    unless @get('phone')
      errors.addObject gettext('Phone field must not be blank')
    return errors
env = undefined
store = undefined

module "DS.Model / Vosae.ReportSettings",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'property - fontName', ->
  # Setup
  store.push 'reportSettings', {id: 1}

  # Test
  store.find('reportSettings', 1).then async (reportSettings) ->
    fontFamily = Vosae.Config.reportFontFamilies.findProperty 'value', reportSettings.get('fontName')
    notEqual fontFamily, undefined, "fontName default value should exist in the supported font families"

test 'computedProperty - defaultLanguage', ->
  # Setup
  store.push 'reportSettings', {id: 1, language: "fr"}

  # Test
  store.find('reportSettings', 1).then async (reportSettings) ->
    equal reportSettings.get('defaultLanguage'), Vosae.Config.languages.findProperty('code', 'fr'), "defaultLanguage should return the language object according to the country code"

test 'computedProperty - otherLanguages', ->
  # Setup
  store.push 'reportSettings', {id: 1, language: "fr"}

  # Test
  store.find('reportSettings', 1).then async (reportSettings) ->
    otherLanguages = Vosae.Config.languages.filter (language)->
      if language.get('code') != "fr"
        return language
    deepEqual reportSettings.get('otherLanguages'), otherLanguages, "otherLanguages should return an array of language without the default language"
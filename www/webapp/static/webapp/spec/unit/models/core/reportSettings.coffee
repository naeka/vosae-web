store = null

describe 'Vosae.ReportSettings', ->
  beforeEach ->
    store = Vosae.Store.create()

  afterEach ->
    store.destroy()

  it 'fontName property default value should exist in the supported font families list', ->
    # Setup
    reportSettings = store.createRecord Vosae.ReportSettings, {}

    # Test
    expect(Vosae.reportFontFamilies.findProperty('value', reportSettings.get('fontName'))).not.toBeUndefined()

  it 'defaultLanguage computed property should return the language object according to the country code', ->
    # Setup
    store.adapterForType(Vosae.ReportSettings).load store, Vosae.ReportSettings, {id: 1, language: "fr"}
    reportSettings = store.find Vosae.ReportSettings, 1

    # Test
    expect(reportSettings.get('defaultLanguage')).toEqual Vosae.languages.findProperty('code', 'fr')

  it 'otherLanguages computed property should return an array of language object different than the default language ', ->
    # Setup
    store.adapterForType(Vosae.ReportSettings).load store, Vosae.ReportSettings, {id: 1, language: "fr"}
    reportSettings = store.find Vosae.ReportSettings, 1
    otherLanguages = Vosae.languages.filter (language)->
      if language.get('code') != "fr"
        return language

    # Test
    expect(reportSettings.get('otherLanguages')).toEqual otherLanguages
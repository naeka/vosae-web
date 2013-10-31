store = null

describe 'Vosae.ReminderSettings', ->
  beforeEach ->
    comp = getAdapterForTest(Vosae.ReminderSettings)
    ajaxUrl = comp[0]
    ajaxType = comp[1]
    ajaxHash = comp[2]
    store = comp[3]

  afterEach ->
    comp = undefined
    ajaxUrl = undefined
    ajaxType = undefined
    ajaxHash = undefined
    store.destroy()

  it 'overrides hasMany relationship', ->
    # Setup
    store.adapterForType(Vosae.ReminderSettings).load store, Vosae.ReminderSettings, 
      id: 1
      overrides:[
        {method: "POPUP", minutes: 10}
      ]
    reminderSettings = store.find Vosae.ReminderSettings, 1
    reminderEntry =  reminderSettings.get('overrides').objectAt 0

    # Test
    expect(reminderSettings.get('overrides.firstObject')).toEqual reminderEntry
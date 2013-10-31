store = null

describe 'Vosae.ReminderEntry', ->
  beforeEach ->
    comp = getAdapterForTest(Vosae.ReminderEntry)
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

  it 'minutes property should be equal to 10 by default', ->
    # Setup
    reminderEntry = store.createRecord Vosae.ReminderEntry, {}

    # Test
    expect(reminderEntry.get('minutes')).toEqual 10

  it 'isPopup computed property should return true if reminder is a popup', ->
    store.adapterForType(Vosae.ReminderEntry).load store, Vosae.ReminderEntry, {id: 1}
    reminderEntry = store.find Vosae.ReminderEntry, 1

    # Test
    expect(reminderEntry.get('isPopup')).toBeFalsy()

    # Setup
    reminderEntry.set 'method', 'SOMETHINGSHITY'

    # Test
    expect(reminderEntry.get('isPopup')).toBeFalsy()

    # Setup
    reminderEntry.set 'method', 'POPUP'

    # Test
    expect(reminderEntry.get('isPopup')).toBeTruthy()

  it 'isEmail computed property should return true if reminder is an email', ->
    store.adapterForType(Vosae.ReminderEntry).load store, Vosae.ReminderEntry, {id: 1}
    reminderEntry = store.find Vosae.ReminderEntry, 1

    # Test
    expect(reminderEntry.get('isEmail')).toBeFalsy()

    # Setup
    reminderEntry.set 'method', 'SOMETHINGSHITY'

    # Test
    expect(reminderEntry.get('isEmail')).toBeFalsy()

    # Setup
    reminderEntry.set 'method', 'EMAIL'

    # Test
    expect(reminderEntry.get('isEmail')).toBeTruthy()

  it 'displayMethod property should return and format the method', ->
    # Setup
    store.adapterForType(Vosae.ReminderEntry).load store, Vosae.ReminderEntry, {id: 1}
    reminderEntry = store.find Vosae.ReminderEntry, 1

    # Test
    expect(reminderEntry.get('displayMethod')).toEqual ''
    Vosae.reminderEntries.forEach (method) ->
      reminderEntry.set 'method', method.get('value')
      expect(reminderEntry.get('displayMethod')).toEqual method.get('displayName')
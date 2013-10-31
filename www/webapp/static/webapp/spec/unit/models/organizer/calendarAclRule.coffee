store = null

describe 'Vosae.CalendarAclRule', ->
  hashCalendarAclRule = 
    rules: []

  beforeEach ->
    comp = getAdapterForTest(Vosae.CalendarAclRule)
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

  it 'principal belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.User).load store, Vosae.User, {id: 1}
    store.adapterForType(Vosae.CalendarAclRule).load store, Vosae.CalendarAclRule, {id: 1, principal: "/api/v1/user/1/", role: "NONE"}
    user = store.find Vosae.User, 1
    calendarAclRule =  store.find Vosae.CalendarAclRule, 1

    # Test
    expect(calendarAclRule.get('principal')).toEqual user

  it 'displayRole property should return and format the role', ->
    # Setup
    store.adapterForType(Vosae.CalendarAclRule).load store, Vosae.CalendarAclRule, {id: 1}
    calendarAclRule =  store.find Vosae.CalendarAclRule, 1

    # Test
    expect(calendarAclRule.get('displayRole')).toEqual ''
    Vosae.calendarAclRuleRoles.forEach (role) ->
      calendarAclRule.set 'role', role.get('value')
      expect(calendarAclRule.get('displayRole')).toEqual role.get('displayName')

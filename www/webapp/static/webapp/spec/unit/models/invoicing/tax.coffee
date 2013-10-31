store = null

describe 'Vosae.Tax', ->
  hashTax = 
    name: null
    rate: null

  beforeEach ->
    comp = getAdapterForTest(Vosae.Tax)
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

  it 'finding all tax makes a GET to /tax/', ->
    # Setup
    taxes = store.find Vosae.Tax
    
    # Test
    enabledFlags taxes, ['isLoaded', 'isValid'], recordArrayFlags
    expectAjaxURL "/tax/"
    expectAjaxType "GET"

    # Setup
    ajaxHash.success(
      meta: {}
      objects: [$.extend({}, hashTax, {id: 1, name: "TVA", rate: 0.196})]
    )
    tax = taxes.objectAt(0)

    # Test
    statesEqual taxes, 'loaded.saved'
    stateEquals tax, 'loaded.saved'
    enabledFlagsForArray taxes, ['isLoaded', 'isValid']
    enabledFlags tax, ['isLoaded', 'isValid']
    expect(tax).toEqual store.find(Vosae.Tax, 1)

  it 'finding a tax by ID makes a GET to /tax/:id/', ->
    # Setup
    tax = store.find Vosae.Tax, 1

    # Test
    stateEquals tax, 'loading'
    enabledFlags tax, ['isLoading', 'isValid']
    expectAjaxType "GET"
    expectAjaxURL "/tax/1/"

    # Setup
    ajaxHash.success($.extend {}, hashTax,
      id: 1
      name: "TVA"
      rate: 0.196
      resource_uri: "/api/v1/tax/1/"
    )

    # Test
    stateEquals tax, 'loaded.saved'
    enabledFlags tax, ['isLoaded', 'isValid']
    expect(tax).toEqual store.find(Vosae.Tax, 1)

  it 'finding taxes by query makes a GET to /tax/:query/', ->
    # Setup
    taxes = store.find Vosae.Tax, {page: 1}

    # Test
    expect(taxes.get('length')).toEqual 0
    enabledFlags taxes, ['isLoading'], recordArrayFlags
    expectAjaxURL "/tax/"
    expectAjaxType "GET"
    expectAjaxData({page: 1 })

    # Setup
    ajaxHash.success(
      meta: {}
      objects: [
        $.extend {}, hashTax, {id: 1, name: "TVA", rate: 0.196}
        $.extend {}, hashTax, {id: 2, name: "TVA2", rate: 0.055}
      ]
    )
    tva = taxes.objectAt 0
    tva2 = taxes.objectAt 1

    # Test
    statesEqual [tva, tva2], 'loaded.saved'
    enabledFlags taxes, ['isLoaded'], recordArrayFlags
    enabledFlagsForArray [tva, tva2], ['isLoaded'], recordArrayFlags
    expect(taxes.get('length')).toEqual 2
    expect(tva.get('name')).toEqual "TVA"
    expect(tva2.get('name')).toEqual "TVA2"
    expect(tva.get('id')).toEqual "1"
    expect(tva2.get('id')).toEqual "2"

  it 'creating a tax makes a POST to /tax/', ->
    # Setup
    tax = store.createRecord Vosae.Tax, {name: "TVA", rate: 0.196 }

    # Test
    stateEquals tax, 'loaded.created.uncommitted'
    enabledFlags tax, ['isLoaded', 'isDirty', 'isNew', 'isValid']

    # Setup
    tax.get('transaction').commit()

    # Test
    stateEquals tax, 'loaded.created.inFlight'
    enabledFlags tax, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']
    expectAjaxURL "/tax/"
    expectAjaxType "POST"
    expectAjaxData($.extend {}, hashTax, {name: "TVA", rate: 0.196})

    # Setup
    ajaxHash.success($.extend {}, hashTax,
      id: 1
      name: "TVA"
      rate: 0.196
      resource_uri: "/api/v1/tax/1/"
    )

    # Test
    stateEquals tax, 'loaded.saved'
    enabledFlags tax, ['isLoaded', 'isValid']
    expect(tax).toEqual store.find(Vosae.Tax, 1)

  it 'updating an tax makes a PUT to /tax/:id/', ->
    # Setup
    store.adapterForType(Vosae.Tax).load store, Vosae.Tax, {
      id: 1
      name: "TVA"
      rate: 0.196
    }
    tax = store.find Vosae.Tax, 1

    # Test
    stateEquals tax, 'loaded.saved' 
    enabledFlags tax, ['isLoaded', 'isValid']

    # Setup
    tax.setProperties {rate: 0.055}

    # Test
    stateEquals tax, 'loaded.updated.uncommitted'
    enabledFlags tax, ['isLoaded', 'isDirty', 'isValid']

    # Setup
    tax.get('transaction').commit()

    # Test
    stateEquals tax, 'loaded.updated.inFlight'
    enabledFlags tax, ['isLoaded', 'isDirty', 'isSaving', 'isValid']
    expectAjaxURL "/tax/1/"
    expectAjaxType "PUT"
    expectAjaxData $.extend({}, hashTax,
      name: "TVA"
      rate: 0.055
    )

    # Setup
    ajaxHash.success $.extend({}, hashTax,
      id: 1
      name: "TVA"
      rate: 0.055
    )

    # Test
    stateEquals tax, 'loaded.saved'
    enabledFlags tax, ['isLoaded', 'isValid']
    expect(tax).toEqual store.find(Vosae.Tax, 1)
    expect(tax.get('rate')).toEqual 0.055

  it 'deleting a tax makes a DELETE to /tax/:id/', ->
    # Setup
    store.adapterForType(Vosae.Tax).load store, Vosae.Tax, {id: 1, name: "TVA", rate: 0.196}
    tax = store.find Vosae.Tax, 1

    # Test
    stateEquals tax, 'loaded.saved' 
    enabledFlags tax, ['isLoaded', 'isValid']

    # Setup
    tax.deleteRecord()

    # Test
    stateEquals tax, 'deleted.uncommitted'
    enabledFlags tax, ['isLoaded', 'isDirty', 'isDeleted', 'isValid']

    # Setup
    tax.get('transaction').commit()

    # Test
    stateEquals tax, 'deleted.inFlight'
    enabledFlags tax, ['isLoaded', 'isDirty', 'isSaving', 'isDeleted', 'isValid']
    expectAjaxURL "/tax/1/"
    expectAjaxType "DELETE"

    # Setup
    ajaxHash.success()

    # Test
    stateEquals tax, 'deleted.saved'
    enabledFlags tax, ['isLoaded', 'isDeleted', 'isValid']

  it 'displayTax property should contact tax name and rate', ->
    # Setup
    store.adapterForType(Vosae.Tax).load store, Vosae.Tax, {id: 1, name: "TVA", rate: 0.196}
    tax = store.find Vosae.Tax, 1

    # Test
    expect(tax.get('displayTax')).toEqual "TVA 19.60%"


  it 'displayRate property should format the tax rate', ->
    # Setup
    store.adapterForType(Vosae.Tax).load store, Vosae.Tax, {id: 1, name: "TVA", rate: 0.196}
    tax = store.find Vosae.Tax, 1

    # Test
    expect(tax.get('displayRate')).toEqual "19.60%"
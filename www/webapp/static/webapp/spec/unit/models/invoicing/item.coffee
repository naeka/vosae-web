store = null

describe 'Vosae.Item', ->
  hashItem = 
    reference: null
    description: null
    unit_price: null
    type: null

  beforeEach ->
    comp = getAdapterForTest(Vosae.Item)
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

  it 'finding all item makes a GET to /item/', ->
    # Setup
    items = store.find Vosae.Item
    
    # Test
    enabledFlags items, ['isLoaded', 'isValid'], recordArrayFlags
    expectAjaxURL "/item/"
    expectAjaxType "GET"

    # Setup
    ajaxHash.success(
      meta: {}
      objects: [$.extend({}, hashItem, {id: 1, ref: "siteweb", unit_price: 1000.64})]
    )
    item = items.objectAt(0)

    # Test
    statesEqual items, 'loaded.saved'
    stateEquals item, 'loaded.saved'
    enabledFlagsForArray items, ['isLoaded', 'isValid']
    enabledFlags item, ['isLoaded', 'isValid']
    expect(item).toEqual store.find(Vosae.Item, 1)

  it 'finding a item by ID makes a GET to /item/:id/', ->
    # Setup
    item = store.find Vosae.Item, 1

    # Test
    stateEquals item, 'loading'
    enabledFlags item, ['isLoading', 'isValid']
    expectAjaxType "GET"
    expectAjaxURL "/item/1/"

    # Setup
    ajaxHash.success($.extend {}, hashItem,
      id: 1
      ref: "siteweb"
      unit_price: 1000
      resource_uri: "/api/v1/item/1/"
    )

    # Test
    stateEquals item, 'loaded.saved'
    enabledFlags item, ['isLoaded', 'isValid']
    expect(item).toEqual store.find(Vosae.Item, 1)

  it 'finding items by query makes a GET to /item/:query/', ->
    # Setup
    items = store.find Vosae.Item, {page: 1}

    # Test
    expect(items.get('length')).toEqual 0
    enabledFlags items, ['isLoading'], recordArrayFlags
    expectAjaxURL "/item/"
    expectAjaxType "GET"
    expectAjaxData({page: 1 })

    # Setup
    ajaxHash.success(
      meta: {}
      objects: [
        $.extend {}, hashItem, {id: 1, reference: "Pen", price: 8.34}
        $.extend {}, hashItem, {id: 2, reference: "Book", price: 34.10}
      ]
    )
    pen = items.objectAt 0
    book = items.objectAt 1

    # Test
    statesEqual [pen, book], 'loaded.saved'
    enabledFlags items, ['isLoaded'], recordArrayFlags
    enabledFlagsForArray [pen, book], ['isLoaded'], recordArrayFlags
    expect(items.get('length')).toEqual 2
    expect(pen.get('ref')).toEqual "Pen"
    expect(book.get('ref')).toEqual "Book"
    expect(pen.get('id')).toEqual "1"
    expect(book.get('id')).toEqual "2"

  it 'creating a item makes a POST to /item/', ->
    # Setup
    item = store.createRecord Vosae.Item, {ref: "Book", unitPrice: 9.45 }

    # Test
    stateEquals item, 'loaded.created.uncommitted'
    enabledFlags item, ['isLoaded', 'isDirty', 'isNew', 'isValid']

    # Setup
    item.get('transaction').commit()

    # Test
    stateEquals item, 'loaded.created.inFlight'
    enabledFlags item, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']
    expectAjaxURL "/item/"
    expectAjaxType "POST"
    expectAjaxData($.extend {}, hashItem, {reference: "Book", unit_price: 9.45})

    # Setup
    ajaxHash.success($.extend {}, hashItem,
      id: 1
      reference: "Book"
      unit_price: 9.45
      resource_uri: "/api/v1/item/1/"
    )

    # Test
    stateEquals item, 'loaded.saved'
    enabledFlags item, ['isLoaded', 'isValid']
    expect(item).toEqual store.find(Vosae.Item, 1)

  it 'updating an item makes a PUT to /item/:id/', ->
    # Setup
    store.adapterForType(Vosae.Item).load store, Vosae.Item, {
      id: 1
      reference: "Book"
      unit_price: 24.53
      type: "PRODUCT"
    }
    item = store.find Vosae.Item, 1

    # Test
    stateEquals item, 'loaded.saved' 
    enabledFlags item, ['isLoaded', 'isValid']

    # Setup
    item.setProperties {unitPrice: 15.00}

    # Test
    stateEquals item, 'loaded.updated.uncommitted'
    enabledFlags item, ['isLoaded', 'isDirty', 'isValid']

    # Setup
    item.get('transaction').commit()

    # Test
    stateEquals item, 'loaded.updated.inFlight'
    enabledFlags item, ['isLoaded', 'isDirty', 'isSaving', 'isValid']
    expectAjaxURL "/item/1/"
    expectAjaxType "PUT"
    expectAjaxData $.extend({}, hashItem,
      reference: "Book"
      unit_price: 15.00
      type: "PRODUCT"
    )

    # Setup
    ajaxHash.success $.extend({}, hashItem,
      id: 1
      reference: "Book"
      unit_price: 15.00
      type: "PRODUCT"
    )

    # Test
    stateEquals item, 'loaded.saved'
    enabledFlags item, ['isLoaded', 'isValid']
    expect(item).toEqual store.find(Vosae.Item, 1)
    expect(item.get('unitPrice')).toEqual 15.00

  it 'deleting a item makes a DELETE to /item/:id/', ->
    # Setup
    store.adapterForType(Vosae.Item).load store, Vosae.Item, {id: 1, ref: "Book", unit_price: 15.00}
    item = store.find Vosae.Item, 1

    # Test
    stateEquals item, 'loaded.saved' 
    enabledFlags item, ['isLoaded', 'isValid']

    # Setup
    item.deleteRecord()

    # Test
    stateEquals item, 'deleted.uncommitted'
    enabledFlags item, ['isLoaded', 'isDirty', 'isDeleted', 'isValid']

    # Setup
    item.get('transaction').commit()

    # Test
    stateEquals item, 'deleted.inFlight'
    enabledFlags item, ['isLoaded', 'isDirty', 'isSaving', 'isDeleted', 'isValid']
    expectAjaxURL "/item/1/"
    expectAjaxType "DELETE"

    # Setup
    ajaxHash.success()

    # Test
    stateEquals item, 'deleted.saved'
    enabledFlags item, ['isLoaded', 'isDeleted', 'isValid']


  it 'tax belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.Tax).load store, Vosae.Tax, {id: 1}
    tax = store.find Vosae.Tax, 1
    store.adapterForType(Vosae.Item).load store, Vosae.Item, {id: 1, tax: "/api/v1/tax/1/"}
    item = store.find Vosae.Item, 1

    # Test
    expect(item.get('tax')).toEqual tax

  it 'currency belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.Currency).load store, Vosae.Currency, {id: 1}
    currency = store.find Vosae.Currency, 1
    store.adapterForType(Vosae.Item).load store, Vosae.Item, {id: 1, currency: "/api/v1/currency/1/"}
    item = store.find Vosae.Item, 1

    # Test
    expect(item.get('currency')).toEqual currency

  it 'displayUnitPrice property should round and format unit price', ->
    # Setup
    store.adapterForType(Vosae.Item).load store, Vosae.Item, {id: 1}
    item = store.find Vosae.Item, 1

    # Test
    expect(item.get('displayUnitPrice')).toEqual undefined

    # Setup
    item.set 'unitPrice', 15.46

    # Test
    expect(item.get('displayUnitPrice')).toEqual "15.46"

    # Setup
    item.set 'unitPrice', 15.460564545

    # Test
    expect(item.get('displayUnitPrice')).toEqual "15.46"

  it 'displayType property should return the item type', ->
    # Setup
    store.adapterForType(Vosae.Item).load store, Vosae.Item, {id: 1, type: "PRODUCT"}
    item = store.find Vosae.Item, 1

    # Test
    expect(item.get('displayType')).toEqual "Product"

    # Setup
    item.set 'type', "SERVICE"

    # Test
    expect(item.get('displayType')).toEqual "Service"

  it 'isEmpty() method should return true if item is empty', ->
    # Setup
    store.adapterForType(Vosae.Item).load store, Vosae.Item, {id: 1}
    item = store.find Vosae.Item, 1

    # Test
    expect(item.isEmpty()).toEqual true

    # Setup
    item.setProperties
      ref: "Book"
      description: "A great book about cooking"
      unit_price: 15.35

    # Test
    expect(item.isEmpty()).toEqual false

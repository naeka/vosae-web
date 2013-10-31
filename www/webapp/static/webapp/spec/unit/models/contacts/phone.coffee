store = null

describe 'Vosae.Phone', ->
  beforeEach ->
    store = Vosae.Store.create()

  afterEach ->
    store.destroy()

  it 'type property should be WORK when creating phone', ->
    # Setup
    phone = store.createRecord Vosae.Phone

    # Test
    expect(phone.get('type')).toEqual "WORK"

  it 'typeIsWork computed property', ->
    # Setup
    phone = store.createRecord Vosae.Phone 

    # Test
    expect(phone.get('typeIsWork')).toEqual true

    # Setup 
    phone.set 'type', 'SomethingShity'

    # Test
    expect(phone.get('typeIsWork')).toEqual false

  it 'typeIsHome computed property', ->
    # Setup
    phone = store.createRecord Vosae.Phone
    phone.set 'type', 'SomethingShity'

    # Test
    expect(phone.get('typeIsHome')).toEqual false

    # Setup
    phone.set 'type', 'HOME'

    # Test
    expect(phone.get('typeIsHome')).toEqual true

  it 'combinedType property', ->
    # Setup
    phone = store.createRecord Vosae.Phone
    phone.set 'type', 'WORK'

    # Test
    expect(phone.get('combinedType')).toEqual 'WORK'

    # Setup
    phone.set 'subtype', 'CELL'

    # Test
    expect(phone.get('combinedType')).toEqual 'WORK-CELL'

  it 'displayCombinedType', ->
    # Setup
    phone = store.createRecord Vosae.Phone
    phone.set 'type', 'WORK'

    # Test
    expect(phone.get('displayCombinedType')).toEqual 'Work'

    # Setup
    phone.set 'subtype', 'CELL'

    # Test
    expect(phone.get('displayCombinedType')).toEqual 'Work cell'

    # Setup
    phone.set 'type', null

    # Test
    expect(phone.get('displayCombinedType')).toEqual ''

    # Setup
    phone.set 'subtype', null

    # Test
    expect(phone.get('displayCombinedType')).toEqual ''

    # Setup
    phone.set 'type', 'SomethingShity'

    # Test
    expect(phone.get('displayCombinedType')).toEqual ''

  it 'combined type changed', ->
    # Setup
    phone = store.createRecord Vosae.Phone
    phone.combinedTypeChanged 'HOME-FAX'

    # Test
    expect(phone.get('type')).toEqual 'HOME'
    expect(phone.get('subtype')).toEqual 'FAX'
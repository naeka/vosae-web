# store = null

# describe 'Vosae.LineItem', ->
#   beforeEach ->
#     store = Vosae.Store.create()

#   afterEach ->
#     store.destroy()

#   it 'tax belongsTo relationship', ->
#     # Setup
#     store.adapterForType(Vosae.Tax).load store, Vosae.Tax, {id: 1}
#     tax = store.find Vosae.Tax, 1
#     store.adapterForType(Vosae.LineItem).load store, Vosae.LineItem, {id: 1, tax: "/api/v1/tax/1/"}
#     lineItem = store.find Vosae.LineItem, 1

#     # Test
#     expect(lineItem.get('tax')).toEqual tax

#   it 'shouldDisableField property should return true if lineItem hasn\'t reference', ->
#     # Setup
#     store.adapterForType(Vosae.LineItem).load store, Vosae.LineItem, {id: 1}
#     lineItem = store.find Vosae.LineItem, 1

#     # Test
#     expect(lineItem.get('shouldDisableField')).toEqual true

#     # Setup
#     lineItem.set 'ref', 'book194'

#     # Test
#     expect(lineItem.get('shouldDisableField')).toEqual false

#   it 'total property should return unit price multiplied by the quantity', ->
#     # Setup
#     store.adapterForType(Vosae.LineItem).load store, Vosae.LineItem, {id: 1}
#     lineItem = store.find Vosae.LineItem, 1

#     # Test
#     expect(lineItem.get('total')).toEqual 0

#     # Setup
#     lineItem.set 'unitPrice', 10
    
#     # Test
#     expect(lineItem.get('total')).toEqual 0
    
#     # Setup
#     lineItem.set 'quantity', 5

#     # Test
#     expect(lineItem.get('total')).toEqual 50

#   it 'totalPlusTax property should return unit price multiplied by the quantity multiplied by the tax', ->
#     # Setup
#     store.adapterForType(Vosae.Tax).load store, Vosae.Tax, {id: 1, rate: 0.196}
#     store.adapterForType(Vosae.LineItem).load store, Vosae.LineItem, {id: 1, tax: "/api/v1/tax/1/"}
#     lineItem = store.find Vosae.LineItem, 1

#     # Test
#     expect(lineItem.get('totalPlusTax')).toEqual 0

#     # Setup
#     lineItem.set 'unitPrice', 10.2
    
#     # Test
#     expect(lineItem.get('totalPlusTax')).toEqual 0
    
#     # Setup
#     lineItem.set 'quantity', 5

#     # Test
#     expect(lineItem.get('totalPlusTax')).toEqual 60.996

#   it 'displayTotal property should return the total formated and rounded', ->
#     # Setup
#     store.adapterForType(Vosae.LineItem).load store, Vosae.LineItem, {id: 1}
#     lineItem = store.find Vosae.LineItem, 1

#     # Test
#     expect(lineItem.get('displayTotal')).toEqual "0.00"

#     # Setup
#     lineItem.setProperties 
#       unitPrice: 10.03434
#       quantity: 5
    
#     # Test
#     expect(lineItem.get('displayTotal')).toEqual "50.17"

#   it 'displayTotalPlusTax property should return the totalPlusTax formated and rounded', ->
#     # Setup
#     store.adapterForType(Vosae.Tax).load store, Vosae.Tax, {id: 1, rate: 0.196}
#     store.adapterForType(Vosae.LineItem).load store, Vosae.LineItem, {id: 1, tax: "/api/v1/tax/1/"}
#     lineItem = store.find Vosae.LineItem, 1

#     # Test
#     expect(lineItem.get('displayTotalPlusTax')).toEqual "0.00"

#     # Setup
#     lineItem.setProperties 
#       unitPrice: 10.2
#       quantity: 5
    
#     # Test
#     expect(lineItem.get('displayTotalPlusTax')).toEqual "61.00"

#   it 'displayUnitPrice property should return the unit price formated and rounded', ->
#     # Setup
#     store.adapterForType(Vosae.LineItem).load store, Vosae.LineItem, {id: 1}
#     lineItem = store.find Vosae.LineItem, 1

#     # Test
#     expect(lineItem.get('displayUnitPrice')).toEqual "0.00"

#     # Setup
#     lineItem.setProperties 
#       unitPrice: 1000000.050
    
#     # Test
#     expect(lineItem.get('displayUnitPrice')).toEqual "1,000,000.05"

#   it 'displayQuantity property should return the quantity formated and rounded', ->
#     # Setup
#     store.adapterForType(Vosae.LineItem).load store, Vosae.LineItem, {id: 1}
#     lineItem = store.find Vosae.LineItem, 1

#     # Test
#     expect(lineItem.get('displayQuantity')).toEqual "0.00"

#     # Setup
#     lineItem.setProperties 
#       quantity: 10000.567
    
#     # Test
#     expect(lineItem.get('displayQuantity')).toEqual "10,000.57"

#   it 'VAT() method should return a dict with the vat amount total and the tax object', ->
#     # Setup
#     store.adapterForType(Vosae.Tax).load store, Vosae.Tax, {id: 1, rate: 0.10}
#     tax = store.find Vosae.Tax, 1
#     store.adapterForType(Vosae.LineItem).load store, Vosae.LineItem, {id: 1, tax: "/api/v1/tax/1/"}
#     lineItem = store.find Vosae.LineItem, 1

#     # Test
#     expect(lineItem.VAT()).toEqual null

#     # Setup
#     lineItem.setProperties 
#       quantity: 10
    
#     # Test
#     expect(lineItem.VAT()).toEqual null

#     # Setup
#     lineItem.setProperties
#       unitPrice: 50

#     # Test
#     expect(lineItem.VAT()).toEqual {total: 50, tax: tax}

#   it 'isEmpty() method should return true if lineItem is empty', ->
#     # Setup
#     store.adapterForType(Vosae.LineItem).load store, Vosae.LineItem, {id: 1}
#     lineItem = store.find Vosae.LineItem, 1

#     # Test
#     expect(lineItem.isEmpty()).toEqual true

#     # Setup
#     lineItem.setProperties
#       ref: "Book"
#       description: "A great book about cooking"
#       unit_price: 15.35

#     # Test
#     expect(lineItem.isEmpty()).toEqual false
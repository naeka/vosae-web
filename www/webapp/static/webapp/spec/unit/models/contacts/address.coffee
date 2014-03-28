# store = null

# describe 'Vosae.Address', ->
#   beforeEach ->
#     store = Vosae.Store.create()

#   afterEach ->
#     store.destroy()

#   it 'type property should be WORK when creating address', ->
#     # Setup
#     address = store.createRecord Vosae.Address

#     # Test
#     expect(address.get('type')).toEqual "WORK"

#   it 'isEmpty computed property', ->
#     # Setup
#     address = store.createRecord Vosae.Address
    
#     # Test
#     expect(address.isEmpty()).toEqual true
    
#     # Setup
#     address.set 'streetAddress', 'SomeContent'

#     # Test
#     expect(address.isEmpty()).toEqual false

#   it 'dumpDatafrom method', ->
#     # Setup
#     address = store.createRecord Vosae.Address
#     address.setProperties
#       type: 'HOME'
#       postofficeBox: 'postofficeBox'
#       streetAddress: 'streetAddress'
#       extendedAddress: 'extendedAddress'
#       postalCode: 'postalCode'
#       city: 'city'
#       state: 'state'
#       country: 'country'
#     newAddress = store.createRecord Vosae.Address
#     newAddress.dumpDataFrom address

#     # Test
#     expect(newAddress.get('type')).toEqual 'HOME'
#     expect(newAddress.get('postofficeBox')).toEqual 'postofficeBox'
#     expect(newAddress.get('streetAddress')).toEqual 'streetAddress'
#     expect(newAddress.get('extendedAddress')).toEqual 'extendedAddress'
#     expect(newAddress.get('postalCode')).toEqual 'postalCode'
#     expect(newAddress.get('city')).toEqual 'city'
#     expect(newAddress.get('state')).toEqual 'state'
#     expect(newAddress.get('country')).toEqual 'country'
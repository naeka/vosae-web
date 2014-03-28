# store = null

# describe 'Vosae.Entity', ->
#   beforeEach ->
#     store = Vosae.Store.create()

#   afterEach ->
#     store.destroy()

#   it 'can add emails', ->
#     # Setup
#     store.load Vosae.Entity, {id: 1}
#     entity = store.find Vosae.Entity, 1
#     email = entity.get('emails').createRecord Vosae.Email
#     email2 = entity.get('emails').createRecord Vosae.Email

#     # Test
#     expect(entity.get('emails.length')).toEqual 2
#     expect(entity.get('emails').objectAt(0)).toEqual email
#     expect(entity.get('emails').objectAt(1)).toEqual email2

#   it 'can add phones', ->
#     # Setup
#     store.load Vosae.Entity, {id: 1}
#     entity = store.find Vosae.Entity, 1
#     phone = entity.get('phones').createRecord Vosae.Phone
#     phone2 = entity.get('phones').createRecord Vosae.Phone

#     # Test
#     expect(entity.get('phones.length')).toEqual 2
#     expect(entity.get('phones').objectAt(0)).toEqual phone
#     expect(entity.get('phones').objectAt(1)).toEqual phone2

#   it 'can add addresses', ->
#     # Setup
#     store.load Vosae.Entity, {id: 1}
#     entity = store.find Vosae.Entity, 1
#     address = entity.get('addresses').createRecord Vosae.Address
#     address2 = entity.get('addresses').createRecord Vosae.Address

#     # Test
#     expect(entity.get('addresses.length')).toEqual 2
#     expect(entity.get('addresses').objectAt(0)).toEqual address
#     expect(entity.get('addresses').objectAt(1)).toEqual address2

#   it 'can delete emails', ->
#     # Setup
#     store.load Vosae.Entity, {id: 1}
#     entity = store.find Vosae.Entity, 1
#     email = entity.get('emails').createRecord Vosae.Email
#     email2 = entity.get('emails').createRecord Vosae.Email

#     # Test
#     expect(entity.get('emails.length')).toEqual 2

#     # Setup
#     entity.get('emails').removeObject email
#     entity.get('emails').removeObject email2

#     # Test
#     expect(entity.get('emails.length')).toEqual 0

#   it 'can delete phones', ->
#     # Setup
#     store.load Vosae.Entity, {id: 1}
#     entity = store.find Vosae.Entity, 1
#     phone = entity.get('phones').createRecord Vosae.Phone
#     phone2 = entity.get('phones').createRecord Vosae.Phone

#     # Test
#     expect(entity.get('phones.length')).toEqual 2

#     # Setup
#     entity.get('phones').removeObject phone
#     entity.get('phones').removeObject phone2

#     # Test
#     expect(entity.get('phones.length')).toEqual 0

#   it 'can delete addresses', ->
#     # Setup
#     store.load Vosae.Entity, {id: 1}
#     entity = store.find Vosae.Entity, 1
#     address = entity.get('addresses').createRecord Vosae.Address
#     address2 = entity.get('addresses').createRecord Vosae.Address

#     # Test
#     expect(entity.get('addresses.length')).toEqual 2

#     # Setup
#     entity.get('addresses').removeObject address
#     entity.get('addresses').removeObject address2

#     # Test
#     expect(entity.get('addresses.length')).toEqual 0

#   # it 'isOwned computed property', ->
#   #   # Setup
#   #   store.load Vosae.Entity, {id: 1}
#   #   store.load Vosae.User, {id: 1}
#   #   store.load Vosae.User, {id: 2}
#   #   entity = store.find Vosae.Entity, 1
#   #   Vosae.user = store.find Vosae.User, 1
#   #   fakeUser = store.find Vosae.User, 2

#   #   # Test    
#   #   expect(entity.get('isOwned')).toEqual false # No creator, should return false

#   #   # Setup
#   #   entity.set 'creator', fakeUser # Creator isn't current VosaeUser, should return false
    
#   #   # Test
#   #   expect(entity.get('isOwned')).toEqual false

#   #   # Setup
#   #   entity.set 'creator', Vosae.get('user')

#   #   # Test
#   #   expect(entity.get('isOwned')).toEqual true

#   it 'private property should be true when creating entity', ->
#     # Setup
#     entity = store.createRecord Vosae.Entity

#     # Test
#     expect(entity.get('private')).toEqual false

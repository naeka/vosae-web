# store = null

# describe 'Vosae.Email', ->
#   beforeEach ->
#     store = Vosae.Store.create()

#   afterEach ->
#     store.destroy()

#   it 'type property should be WORK when creating email', ->
#     # Setup
#     email = store.createRecord Vosae.Email

#     # Test
#     expect(email.get('type')).toEqual 'WORK'

#   it 'displayType computed property', ->
#     # Setup
#     email = store.createRecord Vosae.Email

#     # Test
#     expect(email.get('displayType')).toEqual 'Work'
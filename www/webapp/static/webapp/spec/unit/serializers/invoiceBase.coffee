# serializer = null

# describe 'Vosae.InvoiceBaseSerializer', ->
#   beforeEach ->
#     serializer = Vosae.InvoiceBaseSerializer.create()

#   afterEach ->
#     serializer.destroy()

#   it 'transformRelatedToRelationship method should update the json', ->
#   	# Setup
#   	data = 
#       related_to: '/api/v1/down_payment_invoice/1'
#     json = serializer.transformRelatedToRelationship(data)

#     # Test
#     expect(json['related_down_payment_invoice']).toEqual data['related_to']
#     expect(json.hasOwnProperty('related_to')).toEqual false
###
  Adds support of type date to `DS.Model` attr

  @type date
  @module JSONTransforms
  @namespace DS
###
DS.JSONTransforms.date =
  deserialize: (serialized)->
    type = typeof serialized
    date = null
    if type is "string" or type is "number"
      moment(serialized).toDate()
    else if serialized is null or serialized is `undefined`
      serialized
    else
      null

  serialize: (date)->
    if date instanceof Date or moment.isMoment(date)
      moment(date).format('YYYY-MM-DD')
    else if date is `undefined`
      `undefined`
    else
      null

###
  Adds support of type datetime to `DS.Model` attr

  @type datetime
  @module JSONTransforms
  @namespace DS
###
DS.JSONTransforms.datetime =
  deserialize: (serialized)->
    type = typeof serialized
    date = null
    if type is "string" or type is "number"
      moment(serialized).toDate()
    else if serialized is null or serialized is `undefined`
      serialized
    else
      null

  serialize: (date)->
    if date instanceof Date or moment.isMoment(date)
      moment(date).format()
    else if date is `undefined`
      `undefined`
    else
      null

###
  Adds support of type array to `DS.Model` attr

  @type array
  @module JSONTransforms
  @namespace DS
###
DS.JSONTransforms.array =
  serialize: (serialized)->
    if Em.typeOf(serialized) is 'array'
      return serialized
    return []

  deserialize: (deserialized)->
    if Em.typeOf(deserialized) is 'array'
      return deserialized
    return []

###
  Adds support of type object to `DS.Model` attr

  @type object
  @module JSONTransforms
  @namespace DS
###
DS.JSONTransforms.object =
  deserialize: (serialized) ->
    serialized
  
  serialize: (deserialized) ->
    deserialized

###
  Transforms an array that contains all payment types objects
  See `Vosae.Config.paymentTypes`

  @type paymentTypesArray
  @module JSONTransforms
  @namespace DS
###
DS.JSONTransforms.paymentTypesArray =
  ###
    Serialize an array of objects with label and value
    
    [
      {label: 'Cash', value: 'CASH'},
      {label: 'Credit card', value: 'CREDIT_CARD'}
    ]

    into an array of value

    ['CASH', 'CREDIT_CARD']
  ###
  serialize: (serialized)->
    if Em.typeOf(serialized) is 'array'
      array = []
      serialized.forEach (paymentType) ->
        value = paymentType.get('value')
        array.pushObject(value) if value?
      return array
    return []

  ###
    Transforms an array of value
    
    ['CASH', 'CREDIT_CARD']

    into an array of objects with label and value
    
    [
      {label: 'Cash', value: 'CASH'},
      {label: 'Credit card', value: 'CREDIT_CARD'}
    ]
  ###
  deserialize: (deserialized)->
    if Em.typeOf(deserialized) is 'array'
      array = []
      deserialized.forEach (paymentTypeValue) ->
        paymentTypeObject = Vosae.Config.paymentTypes.findProperty('value', paymentTypeValue)
        array.pushObject(paymentTypeObject) if paymentTypeObject?
      return array
    return []
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

DS.JSONTransforms.array =
  serialize: (serialized)->
    if Em.typeOf(serialized) is 'array'
      return serialized
    return []

  deserialize: (deserialized)->
    if Em.typeOf(deserialized) is 'array'
      return deserialized
    return []

DS.JSONTransforms.paymentTypesArray =
  serialize: (serialized)->
    if Em.typeOf(serialized) is 'array'
      array = []
      serialized.forEach (paymentType) ->
        value = paymentType.get('value')
        array.pushObject(value) if value?
      return array
    return []

  deserialize: (deserialized)->
    if Em.typeOf(deserialized) is 'array'
      array = []
      deserialized.forEach (paymentTypeValue) ->
        paymentTypeObject = Vosae.paymentTypes.findProperty('value', paymentTypeValue)
        array.pushObject(paymentTypeObject) if paymentTypeObject?
      return array
    return []

DS.JSONTransforms.object =
  deserialize: (serialized) ->
    serialized
  
  serialize: (deserialized) ->
    deserialized
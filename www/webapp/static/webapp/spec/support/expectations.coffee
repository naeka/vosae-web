get = Ember.get
set = Ember.set
indexOf = Ember.EnumerableUtils.indexOf
forEach = Ember.EnumerableUtils.forEach

recordArrayFlags = ['isLoaded']
manyArrayFlags = ['isLoaded']

@expectAjaxType = (type) ->
  expect( ajaxType ).toEqual type

@expectAjaxURL = (url) ->
  a = document.createElement 'a'
  a.href = ajaxUrl
  expect( a.pathname ).toEqual "/api/v1#{url}"

@expectAjaxData = (hash) ->
  expect( JSON.parse(JSON.stringify(ajaxHash.data)) ).toEqual JSON.parse(JSON.stringify(hash))

# Used for testing the adapter state path on a single entity
@stateEquals = (entity, expectedState) ->
  actualState = Ember.get(entity, "currentState.stateName")
  actualState = actualState and actualState.replace(/^root\./, "")
  expect(actualState).toEqual(expectedState)

# Used for testing the adapter state path on a collection of entities
@statesEqual = (entities, expectedState) ->
  forEach entities, (entity) ->
    stateEquals entity, expectedState

# Used for testing all of the flags on a single entity
# onlyCheckFlagArr is to only check a subset of possible flags
@enabledFlags = (entity, expectedFlagArr, onlyCheckFlagArr) ->
  possibleFlags = undefined
  if onlyCheckFlagArr
    possibleFlags = onlyCheckFlagArr
  else
    possibleFlags = ["isLoading", "isLoaded", "isReloading", "isDirty", "isSaving", "isDeleted", "isError", "isNew", "isValid"]
  forEach possibleFlags, (flag) ->
    expectedFlagValue = undefined
    actualFlagValue = undefined
    expectedFlagValue = indexOf(expectedFlagArr, flag) isnt -1
    actualFlagValue = entity.get(flag)
    expect(actualFlagValue).toEqual(expectedFlagValue)

# Used for testing all of the flags on a collection of entities
@enabledFlagsForArray = (entities, expectedFlagArr, onlyCheckFlagArr) ->
  forEach entities, (entity) ->
    enabledFlags entity, expectedFlagArr, onlyCheckFlagArr

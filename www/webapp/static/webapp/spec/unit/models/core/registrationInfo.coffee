env = undefined
store = undefined

module "DS.Model / Vosae.RegistrationInfo",
  setup: ->
    env = setupStore()

    # Make the store available for all tests
    store = env.store

test 'method - registrationInfoFor', ->
  # Setup
  store.push 'registrationInfo', {id: 1}

  # Test
  store.find('registrationInfo', 1).then async (regisInfo) ->
    equal regisInfo.registrationInfoFor('BE'), Vosae.BeRegistrationInfo, "calling registrationInfoFor with BE should returns the class BeRegistrationInfo"
    equal regisInfo.registrationInfoFor('CH'), Vosae.ChRegistrationInfo, "calling registrationInfoFor with CH should returns the class ChRegistrationInfo"
    equal regisInfo.registrationInfoFor('FR'), Vosae.FrRegistrationInfo, "calling registrationInfoFor with FR should returns the class FrRegistrationInfo"
    equal regisInfo.registrationInfoFor('GB'), Vosae.GbRegistrationInfo, "calling registrationInfoFor with GB should returns the class GbRegistrationInfo"
    equal regisInfo.registrationInfoFor('LU'), Vosae.LuRegistrationInfo, "calling registrationInfoFor with LU should returns the class LuRegistrationInfo"
    equal regisInfo.registrationInfoFor('US'), Vosae.UsRegistrationInfo, "calling registrationInfoFor with US should returns the class UsRegistrationInfo"
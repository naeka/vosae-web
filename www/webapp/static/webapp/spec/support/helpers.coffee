# @after = (time, func) ->
#   waits(time)
#   jasmine.getEnv().currentSpec.runs(func)

# @once = (condition, func) ->
#   waitsFor(condition)
#   jasmine.getEnv().currentSpec.runs(func)

# @waitFor = waitsFor

# @asyncEqual = (a, b) ->
#   Ember.RSVP.all([Ember.RSVP.resolve(a), Ember.RSVP.resolve(b)]).then async (array) ->
#     expect(array[0]).toBe(array[1])
#   return
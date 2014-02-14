###
  General utility functions

  @class Utilities
  @namespace Vosae
  @module Vosae
###

Vosae.Utilities =

  ###
    Allows us to supply bindings without "binding" to a helper.
  ###
  normalizeHash: (hash, hashTypes) ->
    for prop of hash
      if hashTypes[prop] is "ID"
        hash[prop + "Binding"] = hash[prop]
        delete hash[prop]
    return
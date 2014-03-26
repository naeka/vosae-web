###
  A base model object we can use to handle models in the Vosae client application.

  @class Model
  @extends DS.Model
  @namespace Vosae
  @module Vosae
###

Vosae.Model = DS.Model.extend()

Vosae.Model.reopen
  becameError: ->
    message = "An error happened on #{@toString()}"
    Vosae.ErrorPopup.open
      message: message
###
  A base model object we can use to handle models in the Vosae client application.

  @class Model
  @extends DS.Model
  @namespace Vosae
  @module Vosae
###

Vosae.Model = DS.Model.extend()

# Vosae.Model.reopen
#   becameDirty: ->
#     return if @get('isDirty')
#     if @get('id')
#       @set 'currentState', DS.RootState.loaded.updated.uncommitted
#     else
#       @set 'currentState', DS.RootState.loaded.created.uncommitted

#   becameError: ->
#     message = "An error happened on #{@toString()}"
#     Vosae.ErrorPopupComponent.open
#       message: message

#   resetErrors: ->
#     # Remove errors
#     if !Ember.isNone @get('errors')
#       @set 'errors', null
#     # Flag record has valid
#     if !@get 'isValid'
#       @send 'becameValid'

#   pushError: (key, error) ->
#     if Ember.isNone @get('errors')
#       @set 'errors', {}
#     if Ember.isNone @get('errors')[key]
#       @get('errors')[key] = []
#     if !Ember.isNone error
#       @get('errors')[key].push error
#       if @get 'isValid'
#         @send 'becameInvalid'
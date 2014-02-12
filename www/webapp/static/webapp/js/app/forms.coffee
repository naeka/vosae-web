Bootstrap.Forms = Ember.Namespace.create
  human: (value) ->
    if value is `undefined` or value is false
      return

    # Underscore string
    value = Ember.String.decamelize(value)
    
    # Replace all _ with spaces
    value = value.replace(/_/g, " ")
    
    # Capitalize the first letter of every word
    value = value.replace(/(^|\s)([a-z])/g, (m, p1, p2) ->
      p1 + p2.toUpperCase()
    )
    return value


require 'forms/bootstrap/field'
require 'forms/bootstrap/textField'
require 'forms/bootstrap/select'
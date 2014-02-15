window.Bootstrap = Ember.Namespace.create()
Bootstrap.VERSION = '0.0.1'

if Ember.libraries 
  Ember.libraries.register 'Bootstrap', Bootstrap.VERSION

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
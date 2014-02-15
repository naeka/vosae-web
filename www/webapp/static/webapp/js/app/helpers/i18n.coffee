get = Ember.Handlebars.get

isTranslatedAttribute = /(.+)Translation$/
isBinding = /(.+)Binding$/

getGettextString = (key, attrs) ->
  if attrs.hasOwnProperty('context') and attrs.hasOwnProperty('plural')
    return npgettext(attrs.context, key, attrs.plural, attrs.count)
  if attrs.hasOwnProperty 'context'
    return pgettext(attrs.context, key)
  if attrs.hasOwnProperty 'plural'
    return ngettext(key, attrs.plural, attrs.count)
  return gettext(key)

getTranslated = (key, attrs = {}) ->
  gettext_str = getGettextString(key, attrs)
  template = Handlebars.compile(gettext_str)
  template attrs


###
  Adds I18n methods to the class `Ember.String`
###
Ember.String.gettext = (msgid) ->
  gettext(msgid)

Ember.String.ngettext = (singular, plural, count) ->
  ngettext(singular, plural, count)

Ember.String.gettext_noop = (msgid) ->
  gettext_noop(msgid)

Ember.String.pgettext = (context, msgid) ->
  pgettext(context, msgid)

Ember.String.npgettext = (context, singular, plural, count) ->
  npgettext(context, singular, plural, count)

Ember.String.interpolate = (fmt, obj, named) ->
  interpolate(fmt, obj, named)


###
  Look up a translation for an i18n key in our dictionary

  @method trans
  @for Handlebars
###
Handlebars.registerHelper 'trans', (key, options) ->
  context = this
  attrs = options.hash
  data = options.data
  view = data.view
  tagName = attrs.tagName || 'span'
  delete attrs.tagName

  # Generate a unique id for this element. This will be added as a
  # data attribute to the element so it can be looked up when
  # the bound property changes.
  elementID = "i18n-#{Em.uuid++}"

  Em.keys(attrs).forEach (property)->
    isBindingMatch = property.match(isBinding)
    if isBindingMatch
      # Get the current values for any bound properties:
      propertyName = isBindingMatch[1]
      bindPath = attrs[property]
      currentValue = get context, bindPath, options
      attrs[propertyName] = currentValue

      # Set up an observer for changes:
      invoker = null

      normalized = Ember.Handlebars.normalizePath context, bindPath, data
      [root, normalizedPath] = [normalized.root, normalized.path]

      observer = ()->
        # The view is being rerendered or has been destroyed. In the former case
        # the observer will be added back, and in the latter it should be
        # removed permanently.
        if view.get('state') isnt 'inDOM'
          Em.removeObserver root, normalizedPath, invoker
          return

        newValue = get context, bindPath, options
        elem = view.$ "##{elementID}"

        attrs[propertyName] = newValue
        elem.html getTranslated key, attrs

      invoker = ->
        Em.run.once observer

      Em.addObserver root, normalizedPath, invoker

  result = '<%@ id="%@">%@</%@>'.fmt tagName, elementID, getTranslated(key, attrs), tagName
  new Handlebars.SafeString result
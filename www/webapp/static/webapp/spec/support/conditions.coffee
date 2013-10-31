@notEmpty = (selector) ->
  -> $(selector).text().trim() != ''

@hasText = (selector, text) ->
  -> $(selector).text().trim() == text

@appRendered = -> $('.ember-application').length
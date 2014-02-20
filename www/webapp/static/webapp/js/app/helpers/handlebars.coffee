###
  Iterate on each record of the recordArray and generate index.
   
  @method generateLoopCounter
  @for Handlebars
###
Handlebars.registerHelper "generateLoopCounter", (property, options) ->
  context = (options.fn.contexts and options.fn.contexts[0]) or this
  val = Ember.Handlebars.get(context, property, options)
  if val.get("content.length") > 0
    val.objectAt(0).set "isFirstObject", true
    val.objectAt(val.get("length") - 1).set "isLastObject", true
    i = 0
    while i < val.get("length")
      val.objectAt(i).loopCounter = i
      i++
  return


###
  Compares both value and return true if equals.
   
  @method ifEqual
  @for Handlebars
###
Ember.Handlebars.registerHelper "ifEqual", (lvalue, rvalue, options) ->
  context = (options.fn.contexts and options.fn.contexts[0]) or this
  lvalue = Ember.Handlebars.get(context, lvalue, options)
  throw new Error("Handlebars ifEqual Helper needs 2 parameters")  if arguments.length < 3
  unless lvalue is rvalue
    options.inverse this
  else
    options.fn this


###
  Return a date formatted.
  Usage : {{formatDate date format="LLLL"}}

  @method formateDate
  @for Handlebars
###
Ember.Handlebars.registerBoundHelper "formatDate", (date, options) ->
  format = (if options.hash.format then options.hash.format else "LL")
  if date
    return moment(date).format(format)
  return '-'


###
  Return the current time formatted.
  Usage : {{formatNow format="LLLL"}}
  
  @method formatNow
  @for Handlebars
###
Ember.Handlebars.helper "formatNow", (options) ->
  return moment().format(if options.hash.format then options.hash.format else "LL")


###
  Returns a money amount formatted.
  Usage : {{#formatMoneyHack amount symbol}}{{/formatMoneyHack}}
  
  @method formatMoneyHack
  @for Handlebars
###
Ember.Handlebars.registerHelper "formatMoneyHack", (amount, symbol) ->
  options = [].slice.call(arguments, -1)[0]
  params = [].slice.call(arguments, 1, -1)
  context = (options.fn.contexts and options.fn.contexts[0]) or this
  amount = Ember.Handlebars.get(context, amount, options)
  symbol = Ember.Handlebars.get(context, symbol, options)

  symbol = '' unless symbol
  accounting.formatMoney(amount, symbol: symbol)


###
  Returns a money amount formatted.
  Usage : {{formatMoney amount symbol}}
  
  @method formatMoney
  @for Handlebars
###
Ember.Handlebars.registerBoundHelper 'formatMoney', (amount, symbol) ->
  symbol = '' unless symbol
  accounting.formatMoney(amount, symbol: symbol)

  if amount or amount is 0
    return accounting.formatMoney(amount, symbol: symbol)
  return '-'


###
  Convert new line (\n\r) to <br>.
  Usage : {{nl2br content}}

  @method nl2br
  @for Handlebars
###
Ember.Handlebars.registerBoundHelper "nl2br", (text) ->
  text = Handlebars.Utils.escapeExpression(text)
  nl2br = (text + "").replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, "$1" + "<br>" + "$2")
  new Handlebars.SafeString(nl2br)


###
  Returns a money amount formatted.
  Usage : {{stateLabel states state}}

  @method stateLabel
  @for Handlebars
###
Ember.Handlebars.registerBoundHelper 'stateLabel', (states, state) ->
  states.findProperty('value', state).get('label').toLowerCase()


###
  Returns a file size readeable by humans.
  Usage : {{humanFileSize file.size}}
  
  @method humanFileSize
  @for Handlebars
###
Em.Handlebars.registerBoundHelper 'humanFileSize', (bytes, options) ->
  humanFileSize = (bytes, si) ->
    bytes = parseInt(bytes)
    thresh = (if si then 1000 else 1024)
    return bytes + " B"  if bytes < thresh
    units = (if si then ["kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"] else ["KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB"])
    u = -1
    loop
      bytes /= thresh
      ++u
      break unless bytes >= thresh
    bytes.toFixed(1) + " " + units[u]

  humanFileSize(bytes)


###
  Returns true if device is toucheable
  Usage : {{#isTouchEnabled}}{{/isTouchEnabled}}

  @method isTouchDevice
  @for Handlebars
###
Ember.Handlebars.registerHelper "isTouchDevice", (options) ->
  if Vosae.Utilities.isTouchDevice()
    options.fn this
  else
    options.inverse this
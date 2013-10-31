Handlebars.registerHelper "generateLoopCounter", (property, options) ->
  ###
  Iterate on each record of the recordArray and generate index
   
  @recordArray: array

  Usage : {{#generateLoopCounter recordArray}}{{/generateLoopCounter}}
  ###
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


Ember.Handlebars.registerHelper "ifEqual", (lvalue, rvalue, options) ->
  context = (options.fn.contexts and options.fn.contexts[0]) or this
  lvalue = Ember.Handlebars.get(context, lvalue, options)
  throw new Error("Handlebars ifEqual Helper needs 2 parameters")  if arguments.length < 3
  unless lvalue is rvalue
    options.inverse this
  else
    options.fn this


Ember.Handlebars.registerBoundHelper "formatDate", (date, options) ->
  ###
  Return a date formatted.
  
  @date: DS.attr('date')
  @format: DS.attr('string') [optional] default="LL"
  
  Usage : {{formatDate date format="LLLL"}}
  ###
  format = (if options.hash.format then options.hash.format else "LL")
  if date
    return moment(date).format(format)
  return '-'


Ember.Handlebars.helper "formatNow", (options) ->
  ###
  Return the current time formatted.
  
  @format: DS.attr('string') [optional] default="LL"
  
  Usage : {{formatNow format="LLLL"}}
  ###
  return moment().format(if options.hash.format then options.hash.format else "LL")


Ember.Handlebars.registerHelper "formatMoneyHack", (amount, symbol) ->
  ###
  Returns a money amount formatted.
  
  @amount: DS.attr('number')
  @symbol: DS.attr('string')
  
  Usage : {{#formatMoneyHack amount symbol}}{{/formatMoneyHack}}
  ###
  options = [].slice.call(arguments, -1)[0]
  params = [].slice.call(arguments, 1, -1)
  context = (options.fn.contexts and options.fn.contexts[0]) or this
  amount = Ember.Handlebars.get(context, amount, options)
  symbol = Ember.Handlebars.get(context, symbol, options)

  symbol = '' unless symbol
  accounting.formatMoney(amount, symbol: symbol)


Ember.Handlebars.registerBoundHelper 'formatMoney', (amount, symbol) ->
  ###
  Returns a money amount formatted.
  
  @amount: DS.attr('number')
  @symbol: DS.attr('string')
  
  Usage : {{formatMoney amount symbol}}
  ###
  symbol = '' unless symbol
  accounting.formatMoney(amount, symbol: symbol)

  if amount or amount is 0
    return accounting.formatMoney(amount, symbol: symbol)
  return '-'


Ember.Handlebars.registerHelper "isTouchEnabled", (options) ->
  ###
  Returns true if device is toucheable
  
  Usage : {{#isTouchEnabled}}{{/isTouchEnabled}}
  ###
  if @get("controllers.application").isTouchDevice()
    options.fn this
  else
    options.inverse this


Ember.Handlebars.registerBoundHelper "nl2br", (text) ->
  ###
  Convert new line (\n\r) to <br>

  @text: DS.attr('string')
  
  Usage : {{nl2br content}}
  ###
  text = Handlebars.Utils.escapeExpression(text)
  nl2br = (text + "").replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, "$1" + "<br>" + "$2")
  new Handlebars.SafeString(nl2br)


Ember.Handlebars.registerBoundHelper 'stateLabel', (states, state) ->
  ###
  Returns a money amount formatted.
  
  @states: Array
  @symbol: DS.attr('string')
  
  Usage : {{stateLabel states state}}
  ###
  states.findProperty('value', state).get('label').toLowerCase()


Em.Handlebars.registerBoundHelper 'humanFileSize', (bytes, options) ->
  ###
  Returns a file size readeable by humans.
  
  @bytes: String
  
  Usage : {{humanFileSize file.size}}
  ###

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
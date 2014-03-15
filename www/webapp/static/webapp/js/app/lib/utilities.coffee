###
  General utility functions

  @class Utilities
  @namespace Vosae
  @module Vosae
###

Vosae.Utilities =

  WRAPPER_LOADER_ID: "#wrapper-loader"
  CURRENT_LANGUAGE: null

  TIMELINE_MODELS: [
    'contactSavedTE'
    'organizationSavedTE'
    'quotationSavedTE'
    'invoiceSavedTE'
    'downPaymentInvoiceSavedTE'
    'creditNoteSavedTE'
    'quotationChangedStateTE'
    'invoiceChangedStateTE'
    'downPaymentInvoiceChangedStateTE'
    'creditNoteChangedStateTE'
    'quotationMakeInvoiceTE'
    'quotationMakeDownPaymentInvoiceTE'
    'invoiceCancelledTE'
    'downPaymentInvoiceCancelledTE'
  ]

  NOTIFICATION_MODELS: [
    'contactSavedNE'
    'organizationSavedNE'
    'quotationSavedNE'
    'invoiceSavedNE'
    'downPaymentInvoiceSavedNE'
    'creditNoteSavedNE'
    'eventReminderNE'
  ]

  ###
    Updates prototypes to add usefull methods
  ###
  updatePrototypes: ->
    unless typeof String::startsWith is "function"
      String::startsWith = (str) -> @slice(0, str.length) is str
    return

  ###
    Returns true if obj is an array
  ###
  isArray: (obj) ->
    Object.prototype.toString.call(obj) is '[object Array]'

  ###
    Allows us to supply bindings without "binding" to a helper.
  ###
  normalizeHash: (hash, hashTypes) ->
    for prop of hash
      if hashTypes[prop] is "ID"
        hash[prop + "Binding"] = hash[prop]
        delete hash[prop]
    return

  ###
    Check is email is valid
  ###
  emailIsValid: (email) ->
    # See:  http://stackoverflow.com/questions/46155/validate-email-address-in-javascript
    re = /^[a-zA-Z0-9!#$%&'*+\/=?\^_`{|}~\-]+(?:\.[a-zA-Z0-9!#$%&'\*+\/=?\^_`{|}~\-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9\-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9\-]*[a-zA-Z0-9])?$/
    re.test email

  ###
    Display the app loader
  ###
  showLoader: ->
    $(Vosae.Utilities.WRAPPER_LOADER_ID).fadeIn()
    return

  ###
    Hide app loader
  ###
  hideLoader: ->
    $(Vosae.Utilities.WRAPPER_LOADER_ID).fadeOut()
    return

  ###
    Set new title to page
  ###
  setPageTitle: (title) ->
    $(document).attr 'title', "#{title} - Vosae"
    return

  ### 
    Configure the i18n according to the language
  ###
  setLanguage: (language) ->
    Vosae.Session.CURRENT_LANGUAGE = language
    moment.lang language
    return

  ###
    Configure jQuery plugins depending on our needs
  ###
  configPlugins: ->
    # jQuery file upload
    $.widget 'blueimp.fileupload', $.blueimp.fileupload,
      options:
        messages:
          acceptFileTypes: gettext("File type not allowed")
          maxFileSize: gettext("This file is too large")
          maxNumberOfFiles: gettext("The maximum number of files exceeded")
          minFileSize: gettext("This file is too small")
          uploadedBytes: gettext("Uploaded datas exceed file size")
        maxFileSize: 2000000
        minFileSize: 500
        maxNumberOfFiles: 1
        processfail: (e, data) =>
          if data.files[data.index].error
            alert(data.files[data.index].name + ' : ' + data.files[data.index].error)

    return

  ###
    Returns a cookie according to his name
  ###
  getCookie: (name) ->
    cookieValue = null
    if document.cookie and document.cookie isnt ""
      cookies = document.cookie.split(";")
      i = 0

      while i < cookies.length
        cookie = jQuery.trim(cookies[i])
        
        # Does this cookie string begin with the name we want?
        if cookie.substring(0, name.length + 1) is (name + "=")
          cookieValue = decodeURIComponent(cookie.substring(name.length + 1))
          break
        i++
    cookieValue

  ###
    Test if HTTP method require CSRF protection
  ###
  csrfSafeMethod: (method) ->
    /^(GET|HEAD|OPTIONS|TRACE)$/.test method

  ###
    Add CSRFToken to the ajax headers
  ###
  addCSRFToken: ->  
    $.ajaxSetup
      crossDomain: false # obviates need for sameOrigin test
      headers:
        "X-CSRFToken": Vosae.Utilities.getCookie("csrftoken")
      xhrFields:
        withCredentials: true
    return

  ###
    Create a google map with the passed address, render it in the
    selector.
  ###
  createGoogleMap: (selector, address, options) ->
    defaults =
      map:
        address: "3 Rue Général Ferrié 38100 Grenoble France"
        options:
          streetViewControl: false
          mapTypeId: google.maps.MapTypeId.ROADMAP
          mapTypeControl: false
          draggable: false
          scrollwheel: false
          zoom: 17
      marker:
        address: "3 Rue Général Ferrié 38100 Grenoble France"
        options:
          draggable: false

    opts = $.extend true, {}, defaults,
      if address? then {
        map:{ 
          address: address
        },
        marker: {
          address: address 
        }
      } else {}
    return selector.gmap3 opts

  ###
    Check if the current device is touch device
  ###
  isTouchDevice: ->
    (('ontouchstart' in window) || (navigator.msMaxTouchPoints > 0))

  ###
    Returns a function, that, as long as it continues to be invoked, will not
    be triggered. The function will be called after it stops being called for
    N milliseconds. If `immediate` is passed, trigger the function on the
    leading edge, instead of the trailing.
  ###
  debounce: (func, wait, immediate) ->
    timeout = undefined
    args = undefined
    context = undefined
    timestamp = undefined
    result = undefined

    later = ->
      last = moment().valueOf() - timestamp
      if last < wait
        timeout = setTimeout(later, wait - last)
      else
        timeout = null
        unless immediate
          result = func.apply(context, args)
          context = args = null
      return

    ->
      context = this
      args = arguments
      timestamp = moment().valueOf()
      callNow = immediate and not timeout
      timeout = setTimeout(later, wait)  unless timeout
      if callNow
        result = func.apply(context, args)
        context = args = null
      result

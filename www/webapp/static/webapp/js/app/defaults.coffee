unless typeof String::startsWith is "function"
  String::startsWith = (str) ->
    @slice(0, str.length) is str

window.typeIsArray = Array.isArray || ( value ) -> return {}.toString.call( value ) is '[object Array]'

window.getCookie = getCookie = (name) ->
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

window.csrfSafeMethod = csrfSafeMethod = (method) ->
  # these HTTP methods do not require CSRF protection
  /^(GET|HEAD|OPTIONS|TRACE)$/.test method

# Add CSRFToken to the ajax headers
$.ajaxSetup
  crossDomain: false # obviates need for sameOrigin test
  headers:
    "X-CSRFToken": getCookie("csrftoken")
  xhrFields:
    withCredentials: true

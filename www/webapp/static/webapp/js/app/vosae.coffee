require 'defaults'
require 'namespaces'
require 'application'

window.preWindowLocation = preWindowLocation =
  pathname: window.location.pathname
  protocol: window.location.protocol
  host: window.location.host

if !window.testMode
  origin = preWindowLocation.protocol + '//' + preWindowLocation.host
  window.history.pushState {}, "", origin

window.Vosae = VosaeApplication.create preWindowLocation: preWindowLocation
Vosae.deferReadiness()

require 'mixins'
require 'objects'
require 'helpers'
require 'store'
require 'models'

unless window.testMode
  Vosae.run()

require 'components'
require 'router'
require 'controllers'
require 'forms'
require 'views'

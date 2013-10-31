Vosae.ApplicationController = Ember.Controller.extend
  needs: ['notifications', 'search', 'realtime', 'tenantsShow'],
  
  isDashboard: (->
    @get('currentRoute') == 'dashboard'
  ).property 'currentRoute'

  isContacts: (->
    @get('currentRoute') == 'contacts'
  ).property 'currentRoute'

  isOrganizer: (->
    @get('currentRoute') == 'organizer'
  ).property 'currentRoute'

  isInvoicing: (->
    @get('currentRoute') == 'invoicing'
  ).property 'currentRoute'

  isTenantsShow: (->
    @get('currentRoute') == 'tenants.show'
  ).property 'currentRoute'

  isTenantsAdd: (->
    @get('currentRoute') == 'tenants.add'
  ).property 'currentRoute'

  currentPathChanged: (->
    # Google Analytics   
    Ember.run.next ->
      if _gaq? and !Ember.isNone(_gaq)
        page = if window.location.hash.length > 0 then window.location.hash.substring(1) else window.location.pathname
        _gaq.push ["_trackPageview", page.split('/').removeAt(1, 1).join('/')]
        _gaq.push(['_setCustomVar', 1, 'Member Type', 'Registered', 1])
  ).observes 'currentPath'
  
  showAddressMap: (selector, address, options) ->
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

  isTouchDevice: ->
    return (('ontouchstart' in window) || (navigator.msMaxTouchPoints > 0))
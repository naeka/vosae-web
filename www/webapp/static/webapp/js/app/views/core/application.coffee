Vosae.ApplicationView = Em.View.extend
  elementId: "wrapper"
  
  init: ->
    @_super()
    @zoneFocusEvents()
    @onResizeWindow()
    @transitionEndCallback()

  actions:
    # Expend the left panel
    openPanelLeft: ->
      if not @panelLeftIsOpen()
        $("body").addClass('enable-transformX').addClass("ct-left-open")

        $("#ct-middle").one "click", (e) ->
          e.stopPropagation()
          $("#ct-middle").trigger("zoneFocus")
          return false

        windHeight = $(window).height()

        $("#ct-middle, #ct-left").css
          "min-height": windHeight
          "max-height": windHeight

    # Expend the right panel
    openPanelRight: ->
      if not @panelRightIsOpen()
        $("body").addClass('enable-transformX').addClass("ct-right-open")

        $("#ct-middle").one "click", (e) ->
          e.stopPropagation()
          $("#ct-middle").trigger("zoneFocus")
          return false

        windHeight = $(window).height()

        $("#ct-middle, #ct-right").css
          "min-height": windHeight
          "max-height": windHeight

  didInsertElement: ->
    @get('controller').propertyDidChange('currentRoute')
    $(window).trigger "resize"

  # Return true if left panel is opened
  panelLeftIsOpen: ->
    if $("body").hasClass("ct-left-open")
      return true
    false

  # Return true if right panel is opened
  panelRightIsOpen: ->
    if $("body").hasClass("ct-right-open")
      return true
    false

  # Return true in case toucheable device
  isTouchDevice: ->
    (('ontouchstart' in window) || (navigator.msMaxTouchPoints > 0))

  # HTML events handlers
  drop: (e) ->
    e.preventDefault()
    $("body").removeClass "draggingOn"

  dragOver: (e) ->
    e.preventDefault()

  dragEnter: (e) ->
    $("body").addClass "draggingOn"
  
  dragLeave: (e) ->
    if e.originalEvent.clientX <= 0 or e.originalEvent.clientY <= 0
      $("body").removeClass "draggingOn"

  onResizeWindow: ->
    $(window).resize ->
      menuHeight = $("#desktop-app-menu").outerHeight()
      minContentHeight = $(window).height() - 50 - 54
      
      if minContentHeight < menuHeight
        $('.content-min-height').css "min-height", menuHeight
      else
        $('.content-min-height').css "min-height", minContentHeight

  zoneFocusEvents: ->
    self = @

    # Content
    $(document).on "zoneFocus", "#ct-middle", ->   
      # Flag notifications as read
      if self.panelLeftIsOpen()
        self.get('controller.controllers.notifications').markAllAsRead() 
      $("body").removeClass("ct-left-open ct-right-open ct-search-open")

    # Search
    $(document).on "zoneFocus", "#desktop-search-results", (e) ->
      e.stopPropagation()
      $("body").addClass "ct-search-open"
      $(document).one "click", (e) ->
        $("#ct-middle").trigger "zoneFocus"

    # Search
    $(document).on "click", "#desktop-search-field", (e) ->
      e.stopPropagation()
  
  transitionEndCallback: ->
    transitions = "transitionend transitionEnd webkitTransitionEnd oTransitionEnd msTransitionEnd"
    # Fix blinking on transition
    $(document).on transitions, "#ct-middle", ->
      unless $("body").hasClass("ct-left-open") or $("body").hasClass("ct-right-open")
        $("#ct-left, #ct-middle, #ct-right").css
          "min-height": "none"
          "max-height": "none"
        if $("body").hasClass("enable-transformX")
          $("body").removeClass("enable-transformX")

  # orientationChange: ->
  #   $(window).on "orientationchange", ->
      
  #     # Orientation change while left panel is open
  #     if $("body").hasClass("ct-left-open")
  #       wrapHeight = $("#ct-left > .inner").outerHeight()
  #       windHeight = $(window).height()
  #       if windHeight > wrapHeight
  #         $("#ct-middle, #ct-left").css
  #           "min-height": windHeight
  #           "max-height": windHeight
  #       else
  #         $("#ct-middle, #ct-left").css
  #           "min-height": wrapHeight
  #           "max-height": wrapHeight
      
  #     # Orientation change while right panel is open
  #     if $("body").hasClass("ct-right-open")
  #       wrapHeight = $("#ct-right > .inner").outerHeight()
  #       windHeight = $(window).height()
  #       if windHeight > wrapHeight
  #         $("#ct-middle, #ct-right").css
  #           "min-height": windHeight
  #           "max-height": windHeight
  #       else
  #         $("#ct-middle, #ct-right").css
  #           "min-height": wrapHeight
  #           "max-height": wrapHeight


  # openePanelsFromSwipeEvent: ->
  #   pass = false
  
  #   # $("body").on("swipeleft", function(e){
  #   #   if($("body").hasClass('ct-left-open')){
  #   #     @openPanelLeft(e);
  #   #     pass = true;
  #   #   }
  #   #   if(!$("body").hasClass('ct-right-open')){
  #   #     if (pass == false) {
  #   #       @openPanelRight(e);
  #   #     }
  #   #   }
  #   #   pass = false;
  #   # });
  #   # $("body").on("swiperight", function(e){
  #   #   if($("body").hasClass('ct-right-open')){
  #   #     @openPanelLeft(e);
  #   #     pass = true;
  #   #   }
  #   #   if(!$("body").hasClass('ct-left-open')){
  #   #     if (pass == false) {
  #   #       @openPanelRight(e);
  #   #     }
  #   #   }
  #   #   pass = false;
  #   # });

  showAddressMap: (selector, address, options) ->
    defaults =
      action: "addMarker"
      address: "3 Rue Général Ferrié 38100 Grenoble France"
      map:
        streetViewControl: false
        mapTypeId: google.maps.MapTypeId.ROADMAP
        mapTypeControlOptions: 
          mapTypeIds: []
        center: true
        draggable: false
        scrollwheel: false
        zoom: 17
      marker:
        options:
          draggable: false

    opts = $.extend true, {}, defaults,
      if options? then options else {},
      if address? then {address: address} else {}
    selector.gmap3 opts

  # Search field for desktop
  desktopSearchField: Em.TextField.extend
    elementId: "desktop-search-field"
    resultsElementId: "desktop-search-results"
    placeholder: gettext("Type your search here")
    type: "search"
    keyPressDelay: 250
    timer: null

    didInsertElement: ->
      @triggerKeysEvents()

    triggerKeysEvents: ->
      self = this

      activeResultQuery = "#" + @get("resultsElementId") + " li.active"
      firstResultQuery  = "#" + @get("resultsElementId") + " li:not(\".no-result\"):first"
      lastResultQuery   = "#" + @get("resultsElementId") + " li:not(\".no-result\"):last"
      
      # Actions for triggered keys events
      @$().bind "keydown", (e) ->
        keyCode = e.keyCode or e.which
        
        escape = 27
        enter = 13
        arrow =
          up: 38
          down: 40
        
        switch keyCode
          when arrow.up
            prevResult = $(activeResultQuery).prevAll("li")[0]
            self.unselectActiveResult()
            unless prevResult is `undefined`
              $(prevResult).addClass "active"
            else
              $(lastResultQuery).addClass "active"
          when arrow.down
            nextResult = $(activeResultQuery).nextAll("li")[0]
            self.unselectActiveResult()
            unless nextResult is `undefined`
              $(nextResult).addClass "active"
            else
              $(firstResultQuery).addClass "active"
          when enter
            $(activeResultQuery).trigger "click"
          when escape
            $("#ct-middle").trigger "zoneFocus"
      
      # Add active css class on hover
      $("body").on "hover", "#" + self.get("resultsElementId") + " li:not(\".no-result\")", ->
        self.unselectActiveResult()
        $(this).addClass "active"

    unselectActiveResult: ->
      $("#" + @get("resultsElementId") + " li.active").removeClass "active"

    focusIn: (e) ->
      $("#" + @get("resultsElementId")).trigger "zoneFocus" if @get("value").length > 0

    valueDidChange: (->
      self = @

      if @get("value").length is 0
        $("#ct-middle").trigger "zoneFocus"
        self.get("parentView.controller.controllers.search").resetSearchQuery()
      else
        window.clearTimeout @get("timer")
        @set "timer", setTimeout ->
          self.get("parentView.controller.controllers.search").createSearchQuery(self.get("value"), self.get("keyPressDelay"))
    ).observes("value")
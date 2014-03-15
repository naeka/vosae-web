Vosae.TenantView = Ember.View.extend
  
  registerEvents: (->
    @zoneFocusEvents()
    @onResizeWindow()
    @transitionEndCallback()
  ).on "init"

  updateActiveAppLink: (->
    @get('controller.controllers.application').notifyPropertyChange('currentPath')
  ).on "didInsertElement"

  actions:
    ###
      Open the left panel, disable possible infinite scroll listener

    ###
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

        @disableInfiniteScrollListener()


    ###
      Open the right panel
    ###
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
       
        @disableInfiniteScrollListener()

  ###
    Disabled possible infinite scroll listener. As long as we use infinite scroll
    in the left panel for the notifications, we must disable all other listener
    to prevent unwanted behavior.
  ###
  disableInfiniteScrollListener: ->
    id = $("#ct-middle .infinite-scroll").attr('id')
    if id
      view = Ember.View.views[id]
      view.teardownInfiniteScrollListener() if view and view.has('teardownInfiniteScrollListener')
 
  ###
    Re-enable infinite scroll listener. See @disableInfiniteScrollListener for 
    mode explainations.
  ### 
  enableInfiniteScrollListener: ->
    try
      id = $("#ct-middle .infinite-scroll").attr('id')
      if id
        view = Ember.View.views[id]
        view.setupInfiniteScrollListener() if view and view.has('setupInfiniteScrollListener')

  ###
    When window is resized, we need to re-adjust the content's min height
  ###
  onResizeWindow: ->
    $(window).resize ->
      menuHeight = $("#desktop-app-menu").outerHeight()
      minContentHeight = $(window).height() - 50 - 54
      
      if minContentHeight < menuHeight
        $('.content-min-height').css "min-height", menuHeight
      else
        $('.content-min-height').css "min-height", minContentHeight

  ###
    Returns true if the left panel is opened
  ###
  panelLeftIsOpen: ->
    $("body").hasClass("ct-left-open")

  ###
    Returns true if the right panel is opened
  ###
  panelRightIsOpen: ->
    $("body").hasClass("ct-right-open")

  ###
    Handle focus on the different app containers
  ###
  zoneFocusEvents: ->
    # Content
    $(document).on "zoneFocus", "#ct-middle", =>   
      if @panelLeftIsOpen()
        # Flag notifications as read
        @get('controller.controllers.notifications').send('markAllAsRead')
        @enableInfiniteScrollListener()
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

    $(document).on transitions, "#ct-middle", =>
      unless @panelLeftIsOpen() or @panelRightIsOpen()
        $("#ct-left, #ct-middle, #ct-right").css
          "min-height": "none"
          "max-height": "none"
        $("body").removeClass("enable-transformX")

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
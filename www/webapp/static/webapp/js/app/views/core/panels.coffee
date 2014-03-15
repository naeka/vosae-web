Vosae.DesktopLeftPanelView = Em.View.extend Vosae.InfiniteScrollMixin,
  templateName: "desktop-left-panel"
  elementId: "desktop-left-panel"
  classNames: ["desktop"]
  infiniteScrollSelector: "#ct-left"

  actions:
    paginationAction: ->
      @get('controller.controllers.notifications').send "getNextPagination"

  notificationItems: Em.View.extend
    templateName : "notificationItems"
    classNames: ["d-table notifications"]

    notificationEntryView: Em.View.extend
      templateName: "notificationEntry"
      classNames: ["d-row"]
      classNameBindings: ['unread']

      unread: (->
        if @get('content.read') then false else true
      ).property('content.read')
      
      click: (event) ->
        if event.target.nodeName is "A"
          $("#ct-middle").trigger("click")

Vosae.DesktopRightPanelView = Em.View.extend
  templateName: "desktop-right-panel"
  elementId: "desktop-right-panel"
  classNames: ["desktop"]

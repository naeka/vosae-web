Vosae.DesktopLeftPanelView = Em.View.extend
  templateName: "desktop-left-panel"
  elementId: "desktop-left-panel"
  classNames: ["desktop"]

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


Vosae.PhoneLeftPanelView = Em.View.extend
  templateName: "phone-left-panel"
  elementId: "phone-left-panel"
  classNames: ["phone hidden-desktop"]


Vosae.PhoneRightPanelView = Em.View.extend
  templateName: "phone-right-panel"
  elementId: "phone-right-panel"
  classNames: ["phone hidden-desktop"]
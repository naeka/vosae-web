Vosae.dashboardAppFilter = Em.Object.create
  showAppContact: true
  showAppInvoicing: true
  showAppOrganizer: true
  showAppContactAsChanged: false
  showAppInvoicingAsChanged: false
  showAppOrganizerAsChanged: false
 
  resetFilterObservers: ->
    @set "showAppContactAsChanged", false
    @set "showAppInvoicingAsChanged", false
    @set "showAppOrganizerAsChanged", false
 
  observesFilterContact: (->
    @set "showAppContactAsChanged", true
  ).observes("showAppContact")
 
  observesFilterOrganizer: (->
    @set "showAppOrganizerAsChanged", true
  ).observes("showAppOrganizer")
 
  observesFilterInvoicing: (->
    @set "showAppInvoicingAsChanged", true
  ).observes("showAppInvoicing")


Vosae.DashboardShowView = Ember.View.extend Vosae.InfiniteScrollMixin,
  classNames: ["page-show-dashboard"]

  actions:
    startHelpTour: ->
      $(".page-show-dashboard-settings .info a").click()

    paginationAction: ->
      @get('controller').send "getNextPagination"

  timelineItems: Em.View.extend
    templateName : "timelineItems"
    tagName: "ul"
    classNames: ["timeline"]
    filter: Vosae.dashboardAppFilter

    didInsertElement: ->
     $('.cross-bar').addClass('animated')

    timelineEntryView: Em.View.extend
      templateName: "timelineEntry"
      tagName: "li"
      classNames: ["item"]
      classNameBindings : [
        "appShown:show:hide",
        "appShownChanged::no-animation",
        "content.sameIssuer:same-issuer",
        "content.sameModule:same-module",
        "content.module"
      ]
      
      appShown: (->
        switch @get('content.module')
          when 'contacts' then @get('parentView.filter.showAppContact')
          when 'invoicing' then @get('parentView.filter.showAppInvoicing')
          when 'organizer' then @get('parentView.filter.showAppOrganizer')
          else true
      ).property(
        'this.parentView.filter.showAppContact',
        'this.parentView.filter.showAppInvoicing',
        'this.parentView.filter.showAppOrganizer'
      )

      appShownChanged: (->
        switch @get('content.module')
          when 'contacts' then @get('parentView.filter.showAppContactAsChanged')
          when 'invoicing' then @get('parentView.filter.showAppInvoicingAsChanged')
          when 'organizer' then @get('parentView.filter.showAppOrganizerAsChanged')
          else true
      ).property(
        'this.parentView.filter.showAppContactAsChanged',
        'this.parentView.filter.showAppInvoicingAsChanged',
        'this.parentView.filter.showAppOrganizerAsChanged'
      )

  
Vosae.DashboardShowSettingsView = Em.View.extend Vosae.HelpTourMixin,
  classNames: ["page-settings page-show-dashboard-settings"]
  filter: Vosae.dashboardAppFilter

  initHelpTour: ->
    helpTour = @_super()

    # Application
    helpTour.addStep
      element: "#desktop-app-menu"
      title: gettext "Applications"
      content: gettext "You can easily navigate through your <strong>Applications</strong> by clicking on the icons."
      placement: "right"

    # Notifications
    helpTour.addStep
      element: "#desktop-header-notifications"
      title: gettext "Notifications"
      content: gettext "By clicking on the <i>Vosae</i>, you will have an overview of your recent notifications. For example if a colleague edits a contact or quotation you created, you'll know it in realtime!"
      placement: "right"

    # Search
    helpTour.addStep
      element: "#desktop-search-field"
      title: gettext "Search bar"
      content: gettext "Looking for a <strong>Contact</strong>, an <strong>Invoice</strong> or <strong>Events</strong>? Start by typing any keyword and we'll do the rest for you."
      placement: "bottom"

    # Timeline
    helpTour.addStep
      element: ".cross-bar"
      title: gettext "Timeline"
      content: gettext "Everything that happens in <i>Vosae</i> will appear here in realtime, allowing you an easy overview of your company."
      placement: "top"

    #Timeline
    helpTour.addStep
      element: ".helptour-timelineoptions"
      title: gettext "Timeline options"
      content: gettext "You can hide or reveal any app in the <i>Timeline</i>. It's very useful if you have a lot of informations displayed."
      placement: "left"

    # Settings
    helpTour.addStep
      element: "#desktop-header-settings"
      title: gettext "Settings and Logout"
      content: gettext "Want to change your settings, add a new organization, contact the <strong>Support</strong> or logout from <i>Vosae</i> ? This is the right place to click !"
      placement: "left"

    # Settings
    helpTour.addStep
      element: ".page-show-dashboard-settings .helptour-info"
      title: gettext "More informations"
      content: gettext "On almost every page, you can get more information and some tips by clicking on <strong>Info</strong>!"
      placement: "left"
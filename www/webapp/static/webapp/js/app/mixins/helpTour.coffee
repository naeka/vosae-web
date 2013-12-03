Vosae.HelpTour = Ember.Mixin.create
  helpTour: null

  actions:
    startHelpTour: ->
      unless @helpTour
        @initHelpTour()
      @helpTour.restart()

    stopHelpTour: ->
      if @helpTour
        @helpTour.end()
        $('.popover.tour').remove()

  initHelpTour: ->
    @helpTour = new Tour
      labels:
        next: gettext "Next."
        prev: gettext "Prev."
        end: gettext "End tour"

  willDestroyElement: ->
    @send "stopHelpTour"
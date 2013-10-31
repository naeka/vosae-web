Vosae.HelpTour = Ember.Mixin.create
  helpTour: null

  initHelpTour: ->
    @helpTour = new Tour
      labels:
        next: gettext "Next."
        prev: gettext "Prev."
        end: gettext "End tour"

  startHelpTour: ->
    unless @helpTour
      @initHelpTour()
    @helpTour.restart()

  stopHelpTour: ->
    if @helpTour
      @helpTour.end()
      $('.popover.tour').remove()

  willDestroyElement: ->
    @stopHelpTour()
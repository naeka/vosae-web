Vosae.VosaeEventShowView = Em.View.extend
  classNames: ["app-organizer", "page-show-event"]

  calendarView: Em.View.extend
    tagName: "label"
    attributeBindings: ["style"]
    template: Em.Handlebars.compile("{{view.content.displayName}}")

    style: (->
      'background-color: ' + @get('content.color') + '; color: ' + @get('content.textColor')
    ).property('content.color', 'content.textColor')

  attendeeView: Em.View.extend
    classNames: ["attendee-card"]
    tagName: "li"
    templateName: "vosaeEvent/show/attendee"
    expanded: false

    click: (evt)->
      @set('expanded', !@get('expanded'))

Vosae.ShowEventAddressMapView = Em.View.extend
  classNames: ["address-map"]

  didInsertElement: ->
    if @get('location')
      Vosae.Utilities.createGoogleMap @$(), @get('location')

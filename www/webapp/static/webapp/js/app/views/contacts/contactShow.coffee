Vosae.ContactShowView = Em.View.extend
  classNames: ["app-contacts", "page-show-contact"]

  addQuotationToThis: ->
    controller = @get('controller')
    route = controller.get('target.router').getHandler('quotations.add')
    route.get('preFillQuotationWith').contact = controller.get('content')
    if controller.get('content.organization')
      route.get('preFillQuotationWith').organization = controller.get('content.organization')
    controller.transitionToRoute 'quotations.add', @get('session.tenant')
  
  addInvoiceToThis: ->
    controller = @get('controller')
    route = controller.get('target.router').getHandler('invoices.add')
    route.get('preFillInvoiceWith').contact = controller.get('content')
    if controller.get('content.organization')
      route.get('preFillInvoiceWith').organization = controller.get('content.organization')
    controller.transitionToRoute 'invoices.add', @get('session.tenant')

  showMap: (event) ->
    accordion_body = $($(event.target).closest("a.accordion-toggle").attr("href"))
    vosae_base.showAddressMap accordion_body.find(".map"), accordion_body.data("mapAddress")
    accordion_group = accordion_body.parent()
    if accordion_group.hasClass("active")
      accordion_group.removeClass "active"
    else
      accordion_group.parent().find(".accordion-group.active").removeClass "active"
      accordion_group.addClass "active"

  expandInvoicingTable: ->
    # Append class to selected tr, expand content
    $(document).on "click", ".table-invoices tbody tr:not(.detail), .table-quotations tbody tr:not(.detail)", ->
      $(@).parent().find(".selected").not(@).removeClass "selected"
      $(@).parent().find(".expanded").removeClass "expanded"
      $(@).toggleClass "selected"
      $(@).next().addClass "expanded" if $(@).next().hasClass("detail")


Vosae.ContactShowSettingsView = Em.View.extend Vosae.HelpTour,
  classNames: ["app-contacts", "page-show-contact-settings", "page-settings"]

  initHelpTour: ->
    helpTour = @_super()

    helpTour.addStep
      element: ".page-show-contact .infos"
      title: gettext "Contact informations (required field)"
      content: gettext "This is the <strong>Contact's</strong> information. Add his <i>First name</i> and <i>Last name</i> as well as his <i>Role</i> (e.g. CEO, Product Manager, etc.)."
      placement: "right"

  privateSwitchButton: Vosae.FlipSwitchButton.extend
    change: ->
      contact = @get('controller.content')
      contact.get('transaction').commit()

Vosae.ShowEntityAddressMapView = Em.View.extend
  didInsertElement: ->
    address = $(".accordion-body.in").data("mapAddress")
    if address isnt `undefined`
      selector = $(".accordion-body.in > .map")
    else
      selector = $(".accordion-inner.map.no-address")
    
    # Show map for first address (default)
    @get('controller.controllers.application').showAddressMap selector, address


Vosae.ClickToShowEntityAddressMapView = Em.View.extend
  click: (event) ->
    accordion_body = $($(event.target).closest("a.accordion-toggle").attr("href"))
    @get('controller.controllers.application').showAddressMap accordion_body.find(".map"), accordion_body.data("mapAddress")
    accordion_group = accordion_body.parent()
    if accordion_group.hasClass("active")
      accordion_group.removeClass "active"
    else
      accordion_group.parent().find(".accordion-group.active").removeClass "active"
      accordion_group.addClass "active"

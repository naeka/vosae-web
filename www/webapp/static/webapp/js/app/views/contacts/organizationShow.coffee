Vosae.OrganizationShowView = Em.View.extend
  classNames: ["app-contacts", "page-show-contact", "page-show-organization"]
  
  addQuotationToThis: ->
    controller = @get('controller')
    route = controller.get('target.router').getHandler('quotations.add')
    route.get('preFillQuotationWith').organization = controller.get('content')
    controller.transitionToRoute 'quotations.add', @get('session.tenant')
  
  addInvoiceToThis: ->
    controller = @get('controller')
    route = controller.get('target.router').getHandler('invoices.add')
    route.get('preFillInvoiceWith').organization = controller.get('content')
    controller.transitionToRoute 'invoices.add', @get('session.tenant')
 
  showDetails: ->
    @$().find(".actionsContainer .expand").toggleClass "active"
    @$().find("section.contact-infos, section.quotations, section.invoices").toggleClass "hidden"


Vosae.OrganizationShowSettingsView = Em.View.extend
  classNames: ["app-contacts", "page-settings", "page-show-organization-settings"]

  privateSwitchButton: Vosae.FlipSwitchButton.extend
    change: ->
      organization = @get('controller.content')
      organization.get('transaction').commit()
Vosae.AppInvoicingRoute = Vosae.SelectedTenantRoute.extend
  setupController: ->
    Vosae.lookup('controller:application').set('currentRoute', 'invoicing')

Vosae.InvoicingRoute = Vosae.AppInvoicingRoute.extend()
Vosae.InvoiceRoute = Vosae.AppInvoicingRoute.extend()
Vosae.InvoicesRoute = Vosae.AppInvoicingRoute.extend()
Vosae.QuotationRoute = Vosae.AppInvoicingRoute.extend()
Vosae.QuotationsRoute = Vosae.AppInvoicingRoute.extend()
Vosae.ItemRoute = Vosae.AppInvoicingRoute.extend()
Vosae.ItemsRoute = Vosae.AppInvoicingRoute.extend()
Vosae.CreditNoteRoute = Vosae.AppInvoicingRoute.extend()
Vosae.PurchaseOrdersRoute = Vosae.AppInvoicingRoute.extend()
Vosae.PurchaseOrderRoute = Vosae.AppInvoicingRoute.extend()

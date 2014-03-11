Vosae.TenantsShowView = Vosae.PageTenantView.extend
  classNames: ["outlet-tenants", "page-show-tenants"]

  ###
    If user already selected or tenant or has only one tenant
    he will be automaticaly redirected to the tenant's dashboard,
    otherwise we hide the loader.
  ###
  checkTenants: (->
    preselectedTenant = @get 'controller.session.preselectedTenant'
    tenantsLength = @get('controller.length')
    if not preselectedTenant and tenantsLength != 1
      Vosae.Utilities.hideLoader()
  ).on "didInsertElement"

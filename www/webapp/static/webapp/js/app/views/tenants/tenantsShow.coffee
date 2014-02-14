Vosae.TenantsShowView = Vosae.PageTenantView.extend
  classNames: ["outlet-tenants", "page-show-tenants"]

  didInsertElement: ->
    @_super()

    # If user already selected or tenant or has only one tenant
    # he will be automaticaly redirected to the tenant's dashboard
    preselectedTenant = @get 'controller.session.preselectedTenant'
    tenantsLength = Vosae.Tenant.all().get('length')
    if not preselectedTenant and tenantsLength != 1
      @get('controller.namespace').hideLoader()
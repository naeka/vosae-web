###
  This help us to extract the tenant from the URL before the application
  starts. If a tenant has been found, it will be automatically selected 
  so the user won't have to click on it. It will also contains informations
  about the current session (current tenant, tenantSettings, user).
  It will be injected into views, routes and controllers.

  @class Session
  @namespace Vosae
  @module Vosae
###

Vosae.Session = Ember.Object.extend
  forbidenTenantsNames: ["tenants"]
  preWindowLocation: null
  tenant: null
  tenantSettings: null
  preselectedTenant: null
  nextUrl: null

  parseURL: (->
    unless window.testMode
      location = Vosae.get 'preWindowLocation'
      if location      
        pathname = location.pathname
        tenant = pathname.split('/')[1]

        unless @forbidenTenantsNames.contains tenant
          @preselectedTenant = tenant
          @nextUrl = pathname
  ).on "init"